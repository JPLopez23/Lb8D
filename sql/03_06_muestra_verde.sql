-- Objetivo: Ver una muestra de cinco registros de taxis verdes.
-- Fuente: data/raw/green/2026/green_tripdata_2026-01.parquet
SELECT * FROM read_parquet('../data/raw/green/2026/green_tripdata_2026-01.parquet') LIMIT 5;
