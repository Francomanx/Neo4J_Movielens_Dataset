//EXPERIMENTO 1: Prueba de tiempo de carga de lote

MATCH ()-[r:RATED]->() DELETE r;

:auto
LOAD CSV WITH HEADERS FROM 'file:///ratings.csv' AS row
WITH row LIMIT 5000000
CALL {
  WITH row
  MATCH (u:User {userId: toInteger(row.userId)})
  MATCH (m:Movie {movieId: toInteger(row.movieId)})
  CREATE (u)-[:RATED {rating: toFloat(row.rating)}]->(m)
} IN TRANSACTIONS OF 1000 ROWS;

MATCH ()-[r:RATED]->() DELETE r;

:auto
LOAD CSV WITH HEADERS FROM 'file:///ratings.csv' AS row
WITH row LIMIT 5000000
CALL {
  WITH row
  MATCH (u:User {userId: toInteger(row.userId)})
  MATCH (m:Movie {movieId: toInteger(row.movieId)})
  CREATE (u)-[:RATED {rating: toFloat(row.rating)}]->(m)
} IN TRANSACTIONS OF 5000 ROWS;

MATCH ()-[r:RATED]->() DELETE r;

:auto
LOAD CSV WITH HEADERS FROM 'file:///ratings.csv' AS row
WITH row LIMIT 5000000
CALL {
  WITH row
  MATCH (u:User {userId: toInteger(row.userId)})
  MATCH (m:Movie {movieId: toInteger(row.movieId)})
  CREATE (u)-[:RATED {rating: toFloat(row.rating)}]->(m)
} IN TRANSACTIONS OF 10000 ROWS;