// 01_constraints.cypher
// Creacion de restricciones de unicidad e indices para optimizar la carga y asegurar la integridad de datos.

CREATE CONSTRAINT movie_id IF NOT EXISTS FOR (m:Movie) REQUIRE m.movieId IS UNIQUE;
CREATE CONSTRAINT genre_name IF NOT EXISTS FOR (g:Genre) REQUIRE g.name IS UNIQUE;
CREATE CONSTRAINT user_id IF NOT EXISTS FOR (u:User) REQUIRE u.userId IS UNIQUE;
CREATE CONSTRAINT tag_id IF NOT EXISTS FOR (t:Tag) REQUIRE t.tagId IS UNIQUE;

CREATE INDEX movie_title IF NOT EXISTS FOR (m:Movie) ON (m.title);
