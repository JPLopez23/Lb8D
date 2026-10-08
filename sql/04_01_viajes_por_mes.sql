-- Objetivo: Ver como cambia el numero de viajes mes a mes en cada tipo de taxi.
-- Fuente: vista viajes
SELECT tipo, anio_archivo AS anio, mes_archivo AS mes, count(*) AS viajes
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo
GROUP BY tipo, anio, mes
ORDER BY tipo, anio, mes;
