-- Objetivo: Indicador 5: porcentaje de viajes pagados con tarjeta, efectivo y otros.
-- Fuente: vista viajes
SELECT tipo, make_date(anio_archivo, mes_archivo, 1) AS periodo,
       100.0 * count(*) FILTER (WHERE tipo_pago = 1) / count(*) AS tarjeta,
       100.0 * count(*) FILTER (WHERE tipo_pago = 2) / count(*) AS efectivo,
       100.0 * count(*) FILTER (WHERE tipo_pago NOT IN (1, 2) OR tipo_pago IS NULL) / count(*) AS otros
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo
GROUP BY tipo, periodo
ORDER BY tipo, periodo;
