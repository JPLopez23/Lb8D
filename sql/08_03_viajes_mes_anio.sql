-- Objetivo: Comparar el numero de viajes amarillos de cada mes entre los tres anios.
-- Fuente: vista viajes
PIVOT (
    SELECT mes_archivo AS mes, anio_archivo AS anio, count(*) AS viajes
    FROM viajes
    WHERE year(recogida) = anio_archivo AND month(recogida) = mes_archivo AND tipo = 'amarillo'
    GROUP BY mes, anio
) ON anio USING sum(viajes) ORDER BY mes;
