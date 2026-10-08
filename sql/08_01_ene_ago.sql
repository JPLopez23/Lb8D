-- Objetivo: Comparar los mismos ocho meses, de enero a agosto, entre 2024, 2025 y 2026.
-- Fuente: vista viajes
SELECT tipo, anio_archivo AS anio, count(*) AS viajes,
       round(avg(distancia_mi) FILTER (WHERE distancia_mi > 0 AND distancia_mi < 100), 2) AS distancia_media,
       round(avg(tarifa) FILTER (WHERE tarifa > 0), 2) AS tarifa_media,
       round(100.0 * sum(propina) FILTER (WHERE tipo_pago = 1 AND tarifa > 0) / sum(tarifa) FILTER (WHERE tipo_pago = 1 AND tarifa > 0), 2) AS propina_pct_tarjeta,
       round(100.0 * count(*) FILTER (WHERE tipo_pago = 1) / count(*), 2) AS pct_tarjeta,
       round(100.0 * count(*) FILTER (WHERE tipo_pago = 2) / count(*), 2) AS pct_efectivo
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND mes_archivo <= 8
GROUP BY tipo, anio
ORDER BY tipo, anio;
