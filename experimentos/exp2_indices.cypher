//EXPERIMENTO 2: Impacto del uso de índices en consultas de búsqueda
PROFILE
MATCH (u:User {userId: 45210})-[r:RATED]->(m:Movie)
RETURN u.userId, m.title, r.rating;

CREATE INDEX user_id_index FOR (u:User) ON (u.userId);

PROFILE
MATCH (u:User {userId: 45210})-[r:RATED]->(m:Movie)
RETURN u.userId, m.title, r.rating;
