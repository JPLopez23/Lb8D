-- Objetivo: Indicador 1: viajes por mes y tipo de taxi.
-- Fuente: vista viajes
SELECT tipo, make_date(anio_archivo, mes_archivo, 1) AS periodo, count(*) AS viajes
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo
GROUP BY tipo, periodo
ORDER BY tipo, periodo;
