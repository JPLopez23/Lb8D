-- Objetivo: Indicador 7: ingresos totales por mes en millones de dolares.
-- Fuente: vista viajes
SELECT tipo, make_date(anio_archivo, mes_archivo, 1) AS periodo,
       sum(total) / 1e6 AS ingresos_millones
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND total > 0
GROUP BY tipo, periodo
ORDER BY tipo, periodo;
