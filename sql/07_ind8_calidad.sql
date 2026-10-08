-- Objetivo: Indicador 8: porcentaje de viajes con datos inconsistentes por mes.
-- Fuente: vista viajes
SELECT tipo, make_date(anio_archivo, mes_archivo, 1) AS periodo,
       100.0 * count(*) FILTER (WHERE tarifa <= 0 OR distancia_mi = 0 OR entrega <= recogida) / count(*) AS pct_inconsistentes
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo
GROUP BY tipo, periodo
ORDER BY tipo, periodo;
