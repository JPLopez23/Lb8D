-- Objetivo: Consulta muy selectiva: viajes desde una zona en las primeras horas.
-- Fuente: la vista viajes (archivos Parquet) o la tabla viajes_tabla (tabla materializada en DuckDB).
-- Los marcadores fuente y filtro los reemplaza scripts/benchmark.py para correr la misma consulta con cada estrategia.
SELECT count(*) AS viajes, avg(total) AS total_medio
FROM {fuente}
WHERE {filtro} AND zona_origen = 132 AND hour(recogida) BETWEEN 5 AND 7;
