-- Objetivo: Ver una muestra de cinco registros de taxis amarillos.
-- Fuente: data/raw/yellow/2026/yellow_tripdata_2026-01.parquet
SELECT * FROM read_parquet('../data/raw/yellow/2026/yellow_tripdata_2026-01.parquet') LIMIT 5;
