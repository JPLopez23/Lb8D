-- Objetivo: Confirmar el numero de registros contandolos directamente en los archivos.
-- Fuente: data/raw/yellow/*/*.parquet y data/raw/green/*/*.parquet
SELECT 'amarillo' AS tipo, count(*) AS registros FROM read_parquet('../data/raw/yellow/*/*.parquet', union_by_name = true)
UNION ALL
SELECT 'verde', count(*) FROM read_parquet('../data/raw/green/*/*.parquet', union_by_name = true);
