-- Objetivo: Contar registros con valores sospechosos en cada tipo de taxi.
-- Fuente: vista viajes, que lee todos los archivos Parquet
SELECT tipo, count(*) AS viajes,
       count(*) FILTER (WHERE tarifa < 0)                              AS tarifa_negativa,
       count(*) FILTER (WHERE total <= 0)                              AS total_cero_o_negativo,
       count(*) FILTER (WHERE distancia_mi = 0)                        AS distancia_cero,
       count(*) FILTER (WHERE distancia_mi > 100)                      AS distancia_mayor_100_millas,
       count(*) FILTER (WHERE entrega < recogida)                      AS entrega_antes_de_recogida,
       count(*) FILTER (WHERE entrega - recogida > INTERVAL 1 DAY)     AS duracion_mayor_24_horas,
       count(*) FILTER (WHERE pasajeros IS NULL)                       AS pasajeros_nulos,
       count(*) FILTER (WHERE pasajeros = 0)                           AS pasajeros_cero,
       count(*) FILTER (WHERE pasajeros > 6)                           AS pasajeros_mayor_6,
       count(*) FILTER (WHERE tipo_pago = 0)                           AS tipo_pago_cero,
       count(*) FILTER (WHERE year(recogida) <> anio_archivo OR month(recogida) <> mes_archivo) AS fecha_fuera_de_su_archivo
FROM viajes
GROUP BY tipo
ORDER BY tipo;
