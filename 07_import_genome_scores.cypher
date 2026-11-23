// 07_import_genome_scores.cypher
// Carga de relevancia de genoma desde genome-scores.csv vinculando (:Movie) con (:Tag) mediante [:HAS_GENOME_SCORE]
// NOTA: genome-scores.csv contiene aprox. 14.3 millones de registros. Para cargar una muestra, agregue LIMIT N antes del CALL.

LOAD CSV WITH HEADERS FROM 'file:///genome-scores.csv' AS row
CALL {
    WITH row
    MATCH (m:Movie {movieId: toInteger(row.movieId)})
    MATCH (t:Tag {tagId: toInteger(row.tagId)})
    CREATE (m)-[:HAS_GENOME_SCORE {
        relevance: toFloat(row.relevance)
    }]->(t)
} IN TRANSACTIONS OF 20000 ROWS;
