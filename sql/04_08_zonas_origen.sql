-- Objetivo: Encontrar las diez zonas de origen con mas viajes en cada tipo de taxi.
-- Fuente: vista viajes
SELECT * FROM (
    SELECT tipo, zona_origen, count(*) AS viajes,
           row_number() OVER (PARTITION BY tipo ORDER BY count(*) DESC) AS puesto
    FROM viajes
    WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo
    GROUP BY tipo, zona_origen
)
WHERE puesto <= 10
ORDER BY tipo, puesto;
