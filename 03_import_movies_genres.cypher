// 03_import_movies_genres.cypher
// Carga de peliculas y generos desde movies.csv hacia nodos (:Movie) y (:Genre), vinculados por [:IN_GENRE]

LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row
CALL {
    WITH row
    MERGE (m:Movie {movieId: toInteger(row.movieId)})
    SET m.title = row.title
    WITH m, row
    WHERE row.genres IS NOT NULL AND row.genres <> '(no genres listed)'
    UNWIND split(row.genres, '|') AS genreName
    MERGE (g:Genre {name: genreName})
    MERGE (m)-[:IN_GENRE]->(g)
} IN TRANSACTIONS OF 5000 ROWS;
