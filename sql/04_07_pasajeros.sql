-- Objetivo: Ver cuantos pasajeros se registran por viaje.
-- Fuente: vista viajes
SELECT tipo, coalesce(CAST(pasajeros AS VARCHAR), 'sin dato') AS pasajeros, count(*) AS viajes,
       round(100.0 * count(*) / sum(count(*)) OVER (PARTITION BY tipo), 2) AS porcentaje
FROM viajes
WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo
GROUP BY tipo, pasajeros
ORDER BY tipo, pasajeros NULLS LAST;
