-- Objetivo: Contar los archivos Parquet disponibles por tipo de taxi y anio.
-- Fuente: data/raw/yellow/*/*.parquet y data/raw/green/*/*.parquet
SELECT tipo, anio, count(*) AS archivos
FROM (
    SELECT 'amarillo' AS tipo, regexp_extract(file, '(\d{4})-\d{2}\.parquet', 1) AS anio
    FROM glob('../data/raw/yellow/*/*.parquet') t(file)
    UNION ALL
    SELECT 'verde', regexp_extract(file, '(\d{4})-\d{2}\.parquet', 1)
    FROM glob('../data/raw/green/*/*.parquet') t(file)
)
GROUP BY tipo, anio
ORDER BY tipo, anio;
