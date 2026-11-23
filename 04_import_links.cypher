// 04_import_links.cypher
// Enriquecimiento de nodos (:Movie) con identificadores externos imdbId y tmdbId desde links.csv

LOAD CSV WITH HEADERS FROM 'file:///links.csv' AS row
CALL {
    WITH row
    MATCH (m:Movie {movieId: toInteger(row.movieId)})
    SET m.imdbId = row.imdbId,
        m.tmdbId = CASE WHEN row.tmdbId IS NOT NULL AND row.tmdbId <> '' THEN toInteger(row.tmdbId) ELSE null END
} IN TRANSACTIONS OF 10000 ROWS;
