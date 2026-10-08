-- Objetivo: Comprobar que ahora se pueden consultar juntos los anios 2024, 2025 y 2026.
-- Fuente: vista viajes
SELECT tipo, anio_archivo AS anio, count(DISTINCT mes_archivo) AS meses, count(*) AS viajes
FROM viajes
GROUP BY tipo, anio
ORDER BY tipo, anio;
