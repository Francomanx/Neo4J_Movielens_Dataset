//EXPERIMENTO 3: Impacto de la profundidad de traversal en el tiempo de ejecución

MATCH (u:User {userId: 45210})-[r1:RATED]->(m1:Movie)<-[r2:RATED]-(u2:User)
WHERE r1.rating >= 4.0 AND r2.rating >= 4.0
RETURN u2.userId, count(m1) AS peliculasEnComun
ORDER BY peliculasEnComun DESC LIMIT 10;

MATCH (u:User {userId: 45210})-[r1:RATED]->(m1:Movie)<-[r2:RATED]-(u2:User)-[r3:RATED]->(rec:Movie)
WHERE r1.rating >= 4.0 AND r2.rating >= 4.0 AND r3.rating >= 4.0 
AND NOT (u)-[:RATED]->(rec)
RETURN rec.title, count(*) AS recomendacionScore
ORDER BY recomendacionScore DESC LIMIT 10;

MATCH (u:User {userId: 45210})-[r1:RATED]->(m1:Movie)<-[r2:RATED]-(u2:User)-[r3:RATED]->(m2:Movie)<-[r4:RATED]-(u3:User)
WHERE r1.rating >= 4.0 AND r2.rating >= 4.0 AND r4.rating >= 4.0
RETURN u3.userId, count(DISTINCT m2) AS conexiones
ORDER BY conexiones DESC LIMIT 10;