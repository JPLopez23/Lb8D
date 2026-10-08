-- Objetivo: Mirar los diez viajes con mayor distancia registrada.
-- Fuente: vista viajes
SELECT tipo, recogida, entrega, distancia_mi, tarifa, total
FROM viajes
ORDER BY distancia_mi DESC
LIMIT 10;
