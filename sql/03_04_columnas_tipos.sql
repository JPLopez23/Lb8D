-- Objetivo: Listar las columnas y sus tipos de dato de cada tipo de taxi.
-- Fuente: data/raw/yellow/*/*.parquet y data/raw/green/*/*.parquet
SELECT 'amarillo' AS tipo, column_name AS columna, column_type AS tipo_dato
FROM (DESCRIBE SELECT * FROM read_parquet('../data/raw/yellow/*/*.parquet', union_by_name = true))
UNION ALL
SELECT 'verde', column_name, column_type
FROM (DESCRIBE SELECT * FROM read_parquet('../data/raw/green/*/*.parquet', union_by_name = true))
ORDER BY tipo, columna;
