// 06_import_ratings.cypher
// Carga de calificaciones desde ratings.csv creando nodos (:User) si no existen y la relacion [:RATED] hacia (:Movie)
// NOTA: ratings.csv contiene 25 millones de registros. Para cargar una muestra de prueba, agregue LIMIT N antes del CALL.

LOAD CSV WITH HEADERS FROM 'file:///ratings.csv' AS row
CALL {
    WITH row
    MERGE (u:User {userId: toInteger(row.userId)})
    WITH u, row
    MATCH (m:Movie {movieId: toInteger(row.movieId)})
    CREATE (u)-[:RATED {
        rating: toFloat(row.rating),
        timestamp: datetime({epochSeconds: toInteger(row.timestamp)})
    }]->(m)
} IN TRANSACTIONS OF 20000 ROWS;
