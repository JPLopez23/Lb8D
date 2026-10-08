-- Objetivo: Ver la distribucion de la tarifa en tramos de 5 dolares.
-- Fuente: vista viajes
SELECT tipo, least(floor(tarifa / 5) * 5, 100) AS tramo_desde, count(*) AS viajes
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND tarifa >= 0
GROUP BY tipo, tramo_desde
ORDER BY tipo, tramo_desde;
