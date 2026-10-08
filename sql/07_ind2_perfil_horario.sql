-- Objetivo: Indicador 2: porcentaje de viajes de cada tipo que sale en cada hora del dia.
-- Fuente: vista viajes
SELECT tipo, hour(recogida) AS hora,
       100.0 * count(*) / sum(count(*)) OVER (PARTITION BY tipo) AS porcentaje_viajes
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo
GROUP BY tipo, hora
ORDER BY tipo, hora;
