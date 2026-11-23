// 02_import_genome_tags.cypher
// Carga de etiquetas del genoma desde genome-tags.csv hacia nodos (:Tag)

LOAD CSV WITH HEADERS FROM 'file:///genome-tags.csv' AS row
CALL {
    WITH row
    MERGE (t:Tag {tagId: toInteger(row.tagId)})
    SET t.name = row.tag
} IN TRANSACTIONS OF 1000 ROWS;
