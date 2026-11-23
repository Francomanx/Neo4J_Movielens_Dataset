// 05_import_tags.cypher
// Carga de etiquetas de usuarios desde tags.csv creando nodos (:User) y la relacion [:TAGGED] hacia (:Movie)

LOAD CSV WITH HEADERS FROM 'file:///tags.csv' AS row
CALL {
    WITH row
    MERGE (u:User {userId: toInteger(row.userId)})
    WITH u, row
    MATCH (m:Movie {movieId: toInteger(row.movieId)})
    CREATE (u)-[:TAGGED {
        tag: row.tag,
        timestamp: datetime({epochSeconds: toInteger(row.timestamp)})
    }]->(m)
} IN TRANSACTIONS OF 10000 ROWS;
