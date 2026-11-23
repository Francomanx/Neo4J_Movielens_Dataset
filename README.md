# Neo4J_Movielens_Dataset
Integrantes:
- Franco Arenas
- Jeremi Arriagada
- Luis Gonzalez

# Guia de Instalacion del contenedor en Docker

Para poder cargar la ultima version de Neo4j, basta con utilizar el siguiente codigo en el directorio de tu preferencia, a traves del terminal

```bash
docker run -d --name neo4j-dev -p 7474:7474 -p 7687:7687 -v $HOME/neo4j/data:/data -e NEO4J_AUTH=none neo4j:latest
```

Una vez hecho eso, Puedes probar a acceder al browser de Neo4j mediante el siguiente link: http://localhost:7474/

# Guia de Integracion de Datos MovieLens en Neo4j

---
## Descripcion General del Dataset

El conjunto de datos corresponde a **MovieLens 25M**, generado el 21 de noviembre de 2019 por el grupo de investigacion GroupLens de la Universidad de Minnesota.

Los archivos contenidos en la carpeta raiz son:

| Archivo | Tamano | Filas Aprox. | Descripcion |
| :--- | :--- | :--- | :--- |
| [genome-tags.csv] | 18 KB | 1.128 | Catalogo de etiquetas utilizadas por el modelo Tag Genome. |
| [movies.csv] | 3,0 MB | 62.423 | Identificador, titulo y lista de generos separados por pleca (`\|`). |
| [links.csv] | 1,4 MB | 62.423 | Identificadores externos para enlazar con IMDb y TMDb. |
| [tags.csv] | 38,8 MB | 1.093.360 | Etiquetas de texto libre aplicadas por usuarios a peliculas con timestamp UTC. |
| [ratings.csv] | 678 MB | 25.000.095 | Calificaciones de 0.5 a 5.0 estrellas emitidas por usuarios a peliculas. |
| [genome-scores.csv] | 435 MB | 14.288.400 | Matriz de relevancia entre peliculas y etiquetas de genoma (valores 0.0 a 1.0). |

---

Ejecucion Automatizada via Pipeline

Para ejecutar la carga estructural base de forma automatica y en orden estricto de dependencias, hemos dispuesto del script import_pipeline.sh dentro de la carpeta de scripts.

Ejecute el pipeline desde la terminal (Linux/Mac/Git Bash):
```bash
./scripts/import_pipeline.sh
```

El script realiza:
1. Validacion de que el contenedor `neo4j-dev` este activo.
2. Copiado automatico de los archivos `.csv` a `/var/lib/neo4j/import/`.
3. Creacion de restricciones e indices.
4. Ingesta de `genome-tags.csv`, `movies.csv`, `links.csv` y `tags.csv`.
5. Ejecucion de consultas de validacion y resumen de estado.
