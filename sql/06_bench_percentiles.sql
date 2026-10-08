-- Objetivo: Percentiles de tarifa y distancia.
-- Fuente: la vista viajes (archivos Parquet) o la tabla viajes_tabla (tabla materializada en DuckDB).
-- Los marcadores fuente y filtro los reemplaza scripts/benchmark.py para correr la misma consulta con cada estrategia.
SELECT tipo, quantile_cont(tarifa, [0.5, 0.9, 0.99]) AS tarifa_p, quantile_cont(distancia_mi, [0.5, 0.9, 0.99]) AS distancia_p
FROM {fuente}
WHERE {filtro} AND distancia_mi > 0 AND tarifa > 0
GROUP BY tipo;
