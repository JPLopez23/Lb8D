-- Objetivo: Contar viajes por tipo y mes.
-- Fuente: la vista viajes (archivos Parquet) o la tabla viajes_tabla (tabla materializada en DuckDB).
-- Los marcadores fuente y filtro los reemplaza scripts/benchmark.py para correr la misma consulta con cada estrategia.
SELECT tipo, date_trunc('month', recogida) AS mes, count(*) AS viajes
FROM {fuente}
WHERE {filtro}
GROUP BY tipo, mes
ORDER BY tipo, mes;
