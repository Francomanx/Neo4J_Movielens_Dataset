# Neo4J_Movielens_Dataset

# Guia de Integracion de Datos MovieLens en Neo4j (Contenedor neo4j-dev)

Este documento detalla los pasos tecnicos y estandarizados para integrar el conjunto de datos de MovieLens (ml-25m) alojado en este repositorio dentro de la instancia de Neo4j que opera en el contenedor Docker `neo4j-dev`.

---
## Descripcion General del Dataset

El conjunto de datos corresponde a **MovieLens 25M**, generado el 21 de noviembre de 2019 por el grupo de investigacion GroupLens de la Universidad de Minnesota.

Los archivos contenidos en la carpeta raiz son:

| Archivo | Tamano | Filas Aprox. | Descripcion |
| :--- | :--- | :--- | :--- |
| [genome-tags.csv](file:///home/xter/Desktop/tmp/testNeo4j/genome-tags.csv) | 18 KB | 1.128 | Catalogo de etiquetas utilizadas por el modelo Tag Genome. |
| [movies.csv](file:///home/xter/Desktop/tmp/testNeo4j/movies.csv) | 3,0 MB | 62.423 | Identificador, titulo y lista de generos separados por pleca (`\|`). |
| [links.csv](file:///home/xter/Desktop/tmp/testNeo4j/links.csv) | 1,4 MB | 62.423 | Identificadores externos para enlazar con IMDb y TMDb. |
| [tags.csv](file:///home/xter/Desktop/tmp/testNeo4j/tags.csv) | 38,8 MB | 1.093.360 | Etiquetas de texto libre aplicadas por usuarios a peliculas con timestamp UTC. |
| [ratings.csv](file:///home/xter/Desktop/tmp/testNeo4j/ratings.csv) | 678 MB | 25.000.095 | Calificaciones de 0.5 a 5.0 estrellas emitidas por usuarios a peliculas. |
| [genome-scores.csv](file:///home/xter/Desktop/tmp/testNeo4j/genome-scores.csv) | 435 MB | 14.288.400 | Matriz de relevancia entre peliculas y etiquetas de genoma (valores 0.0 a 1.0). |

---
