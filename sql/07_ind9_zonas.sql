-- Objetivo: Indicador 9: las diez zonas de origen con mas viajes en los tres anios, taxis amarillos.
-- Fuente: vista viajes
SELECT zona_origen, count(*) AS viajes
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND tipo = 'amarillo'
GROUP BY zona_origen
ORDER BY viajes DESC
LIMIT 10;
