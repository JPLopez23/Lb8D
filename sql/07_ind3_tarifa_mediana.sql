-- Objetivo: Indicador 3: tarifa mediana y distancia mediana por mes.
-- Fuente: vista viajes
SELECT tipo, make_date(anio_archivo, mes_archivo, 1) AS periodo,
       approx_quantile(tarifa, 0.5) AS tarifa_mediana,
       approx_quantile(distancia_mi, 0.5) AS distancia_mediana
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND tarifa > 0 AND distancia_mi > 0
GROUP BY tipo, periodo
ORDER BY tipo, periodo;
