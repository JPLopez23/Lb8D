-- Objetivo: Mirar los diez viajes con el total mas negativo.
-- Fuente: vista viajes
SELECT tipo, recogida, tipo_pago, distancia_mi, tarifa, total
FROM viajes
ORDER BY total ASC
LIMIT 10;
