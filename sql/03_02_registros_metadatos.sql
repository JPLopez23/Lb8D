-- Objetivo: Contar registros leyendo solo los metadatos de cada archivo, sin recorrer los datos.
-- Fuente: data/raw/yellow/*/*.parquet y data/raw/green/*/*.parquet
SELECT 'amarillo' AS tipo, count(*) AS archivos, sum(num_rows) AS registros
FROM parquet_file_metadata('../data/raw/yellow/*/*.parquet')
UNION ALL
SELECT 'verde', count(*), sum(num_rows)
FROM parquet_file_metadata('../data/raw/green/*/*.parquet');
