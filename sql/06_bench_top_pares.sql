-- Objetivo: Diez pares de zonas mas frecuentes.
-- Fuente: la vista viajes (archivos Parquet) o la tabla viajes_tabla (tabla materializada en DuckDB).
-- Los marcadores fuente y filtro los reemplaza scripts/benchmark.py para correr la misma consulta con cada estrategia.
SELECT zona_origen, zona_destino, count(*) AS viajes
FROM {fuente}
WHERE {filtro}
GROUP BY zona_origen, zona_destino
ORDER BY viajes DESC
LIMIT 10;
