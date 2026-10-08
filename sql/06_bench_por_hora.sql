-- Objetivo: Viajes y distancia media por hora del dia.
-- Fuente: la vista viajes (archivos Parquet) o la tabla viajes_tabla (tabla materializada en DuckDB).
-- Los marcadores fuente y filtro los reemplaza scripts/benchmark.py para correr la misma consulta con cada estrategia.
SELECT tipo, hour(recogida) AS hora, count(*) AS viajes, avg(distancia_mi) AS distancia_media
FROM {fuente}
WHERE {filtro}
GROUP BY tipo, hora
ORDER BY tipo, hora;
