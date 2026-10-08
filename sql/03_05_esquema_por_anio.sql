-- Objetivo: Ver en que anios aparece cada columna, para detectar cambios de esquema entre archivos.
-- Fuente: data/raw/yellow/*/*.parquet y data/raw/green/*/*.parquet
SELECT tipo, columna, list_sort(list(DISTINCT anio)) AS anios_donde_aparece
FROM (
    SELECT 'amarillo' AS tipo, name AS columna, regexp_extract(file_name, '(\d{4})-\d{2}\.parquet', 1) AS anio
    FROM parquet_schema('../data/raw/yellow/*/*.parquet') WHERE name <> 'schema'
    UNION ALL
    SELECT 'verde', name, regexp_extract(file_name, '(\d{4})-\d{2}\.parquet', 1)
    FROM parquet_schema('../data/raw/green/*/*.parquet') WHERE name <> 'schema'
)
GROUP BY tipo, columna
HAVING count(DISTINCT anio) < 3
ORDER BY tipo, columna;
