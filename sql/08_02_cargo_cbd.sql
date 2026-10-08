-- Objetivo: Ver desde cuando existe el cargo por congestion de la zona central y a cuantos viajes amarillos se les cobra.
-- Fuente: vista viajes
SELECT anio_archivo AS anio, mes_archivo AS mes, count(*) AS viajes,
       round(100.0 * count(*) FILTER (WHERE cargo_cbd > 0) / count(*), 1) AS pct_con_cargo
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND tipo = 'amarillo'
GROUP BY anio, mes
ORDER BY anio, mes;
