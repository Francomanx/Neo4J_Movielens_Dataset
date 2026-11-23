#!/usr/bin/env bash
# import_pipeline.sh
# Automatizacion del copiado y ejecucion de scripts Cypher en el contenedor neo4j-dev.

set -euo pipefail

CONTAINER_NAME="neo4j-dev"
IMPORT_DIR="/var/lib/neo4j/import"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[INFO] Iniciando pipeline de integracion MovieLens en contenedor: ${CONTAINER_NAME}"

# 1. Verificar estado del contenedor
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "[ERROR] El contenedor ${CONTAINER_NAME} no se encuentra en ejecucion."
    exit 1
fi

# 2. Copiar archivos CSV al directorio de importacion de Neo4j
echo "[INFO] Paso 1: Verificando y copiando archivos CSV a ${CONTAINER_NAME}:${IMPORT_DIR}..."
CSV_FILES=("genome-tags.csv" "movies.csv" "links.csv" "tags.csv" "ratings.csv" "genome-scores.csv")
for file in "${CSV_FILES[@]}"; do
    if [ -f "${BASE_DIR}/${file}" ]; then
        echo "       Copiando ${file}..."
        docker cp "${BASE_DIR}/${file}" "${CONTAINER_NAME}:${IMPORT_DIR}/${file}"
    else
        echo "[ADVERTENCIA] Archivo ${file} no encontrado en ${BASE_DIR}, omitiendo copia."
    fi
done

# 3. Funcion auxiliar para ejecutar sentencias Cypher
run_cypher_file() {
    local script_path="$1"
    local script_name
    script_name="$(basename "${script_path}")"
    echo "[INFO] Ejecutando: ${script_name}..."
    docker exec -i "${CONTAINER_NAME}" cypher-shell < "${script_path}"
}

# 4. Ejecutar scripts estructurales en orden estricto de dependencias
echo "[INFO] Paso 2: Creando restricciones e indices..."
run_cypher_file "${BASE_DIR}/scripts/01_constraints.cypher"

echo "[INFO] Paso 3: Importando catalogo de etiquetas de genoma (genome-tags.csv)..."
run_cypher_file "${BASE_DIR}/scripts/02_import_genome_tags.cypher"

echo "[INFO] Paso 4: Importando peliculas y generos (movies.csv)..."
run_cypher_file "${BASE_DIR}/scripts/03_import_movies_genres.cypher"

echo "[INFO] Paso 5: Enriqueciendo peliculas con enlaces externos (links.csv)..."
run_cypher_file "${BASE_DIR}/scripts/04_import_links.cypher"

# 5. Opciones para archivos de alto volumen
if [[ "${1:-}" == "--all" || "${1:-}" == "--with-tags" ]]; then
    echo "[INFO] Paso 6: Importando etiquetas asignadas por usuarios (tags.csv)..."
    run_cypher_file "${BASE_DIR}/scripts/05_import_tags.cypher"
else
    echo "[INFO] Para importar tags.csv (1.093.360 registros), ejecute:"
    echo "       docker exec -i ${CONTAINER_NAME} cypher-shell < ${BASE_DIR}/scripts/05_import_tags.cypher"
    echo "       o invoque este script con: ./scripts/import_pipeline.sh --with-tags"
fi

if [[ "${1:-}" == "--all" ]]; then
    echo "[INFO] Paso 7: Importando calificaciones (ratings.csv)..."
    run_cypher_file "${BASE_DIR}/scripts/06_import_ratings.cypher"

    echo "[INFO] Paso 8: Importando scores de genoma (genome-scores.csv)..."
    run_cypher_file "${BASE_DIR}/scripts/07_import_genome_scores.cypher"
else
    echo "[AVISO] Archivos masivos omitidos por defecto (ratings.csv: ~25M, genome-scores.csv: ~14.3M)."
    echo "Para ejecutarlos individualmente:"
    echo "  docker exec -i ${CONTAINER_NAME} cypher-shell < ${BASE_DIR}/scripts/06_import_ratings.cypher"
    echo "  docker exec -i ${CONTAINER_NAME} cypher-shell < ${BASE_DIR}/scripts/07_import_genome_scores.cypher"
    echo "O ejecutar el pipeline completo con: ./scripts/import_pipeline.sh --all"
fi

echo "[INFO] Verificando estado final de la base de datos:"
docker exec -i "${CONTAINER_NAME}" cypher-shell < "${BASE_DIR}/scripts/verify_database.cypher"

echo "[INFO] Pipeline de carga estructural finalizado exitosamente."
