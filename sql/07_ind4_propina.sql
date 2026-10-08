-- Objetivo: Indicador 4: propina como porcentaje de la tarifa en pagos con tarjeta.
-- Fuente: vista viajes
SELECT tipo, make_date(anio_archivo, mes_archivo, 1) AS periodo,
       100.0 * sum(propina) / sum(tarifa) AS propina_pct
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND tipo_pago = 1 AND tarifa > 0 AND propina >= 0
GROUP BY tipo, periodo
ORDER BY tipo, periodo;
