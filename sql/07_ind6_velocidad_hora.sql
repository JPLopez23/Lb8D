-- Objetivo: Indicador 6: velocidad mediana de los viajes segun la hora del dia.
-- Fuente: vista viajes
SELECT tipo, hour(recogida) AS hora,
       approx_quantile(distancia_mi / (date_diff('second', recogida, entrega) / 3600.0), 0.5) AS mph_mediana
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND distancia_mi > 0.1 AND date_diff('second', recogida, entrega) BETWEEN 60 AND 7200
GROUP BY tipo, hora
ORDER BY tipo, hora;
