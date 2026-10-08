-- Objetivo: Resumen de tarifa y propina por tipo de pago.
-- Fuente: la vista viajes (archivos Parquet) o la tabla viajes_tabla (tabla materializada en DuckDB).
-- Los marcadores fuente y filtro los reemplaza scripts/benchmark.py para correr la misma consulta con cada estrategia.
SELECT tipo, tipo_pago, count(*) AS viajes, avg(tarifa) AS tarifa_media, avg(propina) AS propina_media, sum(total) AS total
FROM {fuente}
WHERE {filtro}
GROUP BY tipo, tipo_pago
ORDER BY tipo, tipo_pago;
