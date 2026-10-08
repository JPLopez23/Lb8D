-- Objetivo: definir una vista unica llamada viajes sobre los archivos Parquet de taxis amarillos y verdes.
-- Fuente: data/raw/yellow/*/*.parquet y data/raw/green/*/*.parquet
-- Decision: la vista usa comodines de carpeta, asi que cualquier archivo nuevo que el script de descarga
--           deje en data/raw entra solo, sin tocar las consultas. union_by_name une los archivos aunque
--           las columnas cambien entre anios. Las columnas se renombran para que ambos taxis tengan el mismo esquema.
CREATE OR REPLACE VIEW viajes AS
SELECT 'amarillo' AS tipo,
       CAST(regexp_extract(filename, '_(\d{4})-(\d{2})\.parquet', 1) AS INTEGER) AS anio_archivo,
       CAST(regexp_extract(filename, '_(\d{4})-(\d{2})\.parquet', 2) AS INTEGER) AS mes_archivo,
       tpep_pickup_datetime  AS recogida,
       tpep_dropoff_datetime AS entrega,
       passenger_count       AS pasajeros,
       trip_distance         AS distancia_mi,
       PULocationID          AS zona_origen,
       DOLocationID          AS zona_destino,
       payment_type          AS tipo_pago,
       fare_amount           AS tarifa,
       tip_amount            AS propina,
       total_amount          AS total,
       cbd_congestion_fee    AS cargo_cbd
FROM read_parquet('../data/raw/yellow/*/*.parquet', union_by_name = true, filename = true)
UNION ALL
SELECT 'verde',
       CAST(regexp_extract(filename, '_(\d{4})-(\d{2})\.parquet', 1) AS INTEGER),
       CAST(regexp_extract(filename, '_(\d{4})-(\d{2})\.parquet', 2) AS INTEGER),
       lpep_pickup_datetime, lpep_dropoff_datetime, passenger_count, trip_distance,
       PULocationID, DOLocationID, payment_type, fare_amount, tip_amount, total_amount,
       cbd_congestion_fee
FROM read_parquet('../data/raw/green/*/*.parquet', union_by_name = true, filename = true);
