-- Objetivo: Describir distancia, duracion y velocidad de los viajes de cada tipo de taxi.
-- Fuente: vista viajes
WITH base AS (
    SELECT tipo, distancia_mi,
           date_diff('second', recogida, entrega) / 60.0 AS minutos,
           distancia_mi / (date_diff('second', recogida, entrega) / 3600.0) AS mph
    FROM viajes
    WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND distancia_mi > 0 AND entrega > recogida
)
SELECT tipo, count(*) AS viajes,
       round(approx_quantile(distancia_mi, 0.5), 2)  AS distancia_mediana,
       round(approx_quantile(distancia_mi, 0.9), 2)  AS distancia_p90,
       round(approx_quantile(distancia_mi, 0.99), 2) AS distancia_p99,
       round(approx_quantile(minutos, 0.5), 1)       AS minutos_mediana,
       round(approx_quantile(minutos, 0.9), 1)       AS minutos_p90,
       round(approx_quantile(minutos, 0.99), 1)      AS minutos_p99,
       round(approx_quantile(mph, 0.5), 1)           AS mph_mediana
FROM base
GROUP BY tipo
ORDER BY tipo;
