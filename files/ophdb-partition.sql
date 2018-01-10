INSERT INTO hostpartition (partitionname) SELECT 'test' FROM DUAL WHERE NOT EXISTS (SELECT * FROM hostpartition WHERE partitionname='test') LIMIT 1;
