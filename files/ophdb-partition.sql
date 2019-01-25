INSERT INTO hostpartition (partitionname) SELECT 'main' FROM DUAL WHERE NOT EXISTS (SELECT * FROM hostpartition WHERE partitionname='main') LIMIT 1;
