-- Objetivo: Ver a que horas y en que dias de la semana se hacen mas viajes.
-- Fuente: vista viajes
SELECT tipo, isodow(recogida) AS dia_semana, hour(recogida) AS hora, count(*) AS viajes
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo
GROUP BY tipo, dia_semana, hora
ORDER BY tipo, dia_semana, hora;
