// verify_database.cypher
// Consultas de verificacion post-importacion

// 1. Resumen de cantidad de nodos por etiqueta
MATCH (n)
RETURN labels(n)[0] AS Etiqueta, count(n) AS CantidadNodos
ORDER BY CantidadNodos DESC;

// 2. Resumen de cantidad de relaciones por tipo
MATCH ()-[r]->()
RETURN type(r) AS TipoRelacion, count(r) AS CantidadRelaciones
ORDER BY CantidadRelaciones DESC;

// 3. Muestra de peliculas con sus generos y enlaces
MATCH (m:Movie)-[:IN_GENRE]->(g:Genre)
RETURN m.movieId AS MovieId, m.title AS Titulo, collect(g.name) AS Generos, m.imdbId AS ImdbId, m.tmdbId AS TmdbId
LIMIT 5;
