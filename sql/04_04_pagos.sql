-- Objetivo: Comparar los tipos de pago: cuantos viajes, tarifa media y propina.
-- Fuente: vista viajes
SELECT tipo, tipo_pago, count(*) AS viajes,
       round(100.0 * count(*) / sum(count(*)) OVER (PARTITION BY tipo), 2) AS porcentaje,
       round(avg(tarifa), 2)  AS tarifa_media,
       round(avg(propina), 2) AS propina_media,
       round(100.0 * sum(propina) / nullif(sum(tarifa) FILTER (WHERE tarifa > 0), 0), 2) AS propina_sobre_tarifa_pct
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo
GROUP BY tipo, tipo_pago
ORDER BY tipo, viajes DESC;
