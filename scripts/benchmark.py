#!/usr/bin/env python3
"""Benchmark: consultar Parquet directamente contra consultar una tabla de DuckDB.

Ejecuta las consultas sql/06_bench_*.sql con dos fuentes:
  - la vista viajes, que lee los archivos Parquet en cada consulta
  - la tabla viajes_tabla, que es la misma informacion materializada en un archivo .duckdb

Cada consulta se repite varias veces y se prueba con cantidades crecientes de datos.
Los resultados se guardan en docs/benchmark.csv.

Uso, desde la carpeta notebooks del proyecto:
    python ../scripts/benchmark.py
    python ../scripts/benchmark.py --repeticiones 5 --db ../data/processed/lab8.duckdb

La base de datos tambien se puede indicar con la variable de entorno LAB8_DB.
"""

import argparse
import os
import time
from pathlib import Path

import duckdb
import pandas as pd

SQL_DIR = Path("../sql")
DOCS_DIR = Path("../docs")

# Cantidades de datos: nombre y condicion sobre las columnas de la vista
TAMANOS = {
    "1 mes (2026-01)": "anio_archivo = 2026 AND mes_archivo = 1",
    "2026 (8 meses)": "anio_archivo = 2026",
    "2025 y 2026": "anio_archivo >= 2025",
    "2024 a 2026": "anio_archivo >= 2024",
}


def conectar(ruta_db: str) -> duckdb.DuckDBPyConnection:
    con = duckdb.connect(ruta_db)
    con.execute("SET memory_limit = '2GB'")
    # Sin conservar el orden de insercion, crear la tabla grande usa mucha menos memoria
    con.execute("SET preserve_insertion_order = false")
    con.execute("SET threads = 2")
    temporal = os.environ.get("LAB8_TEMP")
    if temporal:
        con.execute(f"SET temp_directory = '{temporal}'")
    con.execute((SQL_DIR / "00_vistas.sql").read_text(encoding="utf8"))
    return con


def materializar(con) -> float:
    """Crea la tabla viajes_tabla si no existe y devuelve los segundos que tardo."""
    existe = con.execute(
        "SELECT count(*) FROM information_schema.tables WHERE table_name = 'viajes_tabla'"
    ).fetchone()[0]
    if existe:
        return 0.0
    inicio = time.perf_counter()
    # La tabla se llena mes por mes para no agotar la memoria de la maquina
    con.execute("CREATE TABLE viajes_tabla AS SELECT * FROM viajes LIMIT 0")
    periodos = con.execute("SELECT DISTINCT tipo, anio_archivo, mes_archivo FROM viajes ORDER BY 2, 3, 1").fetchall()
    for tipo, anio, mes in periodos:
        con.execute("INSERT INTO viajes_tabla SELECT * FROM viajes "
                    "WHERE tipo = ? AND anio_archivo = ? AND mes_archivo = ?", [tipo, anio, mes])
        print(f"  cargado {tipo} {anio}-{mes:02d}", flush=True)
    return time.perf_counter() - inicio


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--db", default=os.environ.get("LAB8_DB", "../data/processed/lab8.duckdb"))
    parser.add_argument("--repeticiones", type=int, default=3)
    argumentos = parser.parse_args()

    DOCS_DIR.mkdir(exist_ok=True)
    con = conectar(argumentos.db)
    seg_tabla = materializar(con)
    if seg_tabla:
        print(f"Tabla viajes_tabla creada en {seg_tabla:.1f} s")

    consultas = sorted(SQL_DIR.glob("06_bench_*.sql"))
    filas = []
    for tamano, filtro in TAMANOS.items():
        n = con.execute(f"SELECT count(*) FROM viajes_tabla WHERE {filtro}").fetchone()[0]
        for fuente in ("viajes", "viajes_tabla"):
            for archivo in consultas:
                texto = archivo.read_text(encoding="utf8").format(fuente=fuente, filtro=filtro)
                for rep in range(1, argumentos.repeticiones + 1):
                    inicio = time.perf_counter()
                    con.execute(texto).fetchall()
                    seg = time.perf_counter() - inicio
                    filas.append({"tamano": tamano, "filas": n,
                                  "estrategia": "parquet" if fuente == "viajes" else "tabla",
                                  "consulta": archivo.stem.replace("06_bench_", ""),
                                  "repeticion": rep, "segundos": seg})
                print(f"{tamano:>16} | {fuente:>12} | {archivo.stem:<32} | {seg:6.2f} s", flush=True)

    resultado = pd.DataFrame(filas)
    resultado.to_csv(DOCS_DIR / "benchmark.csv", index=False)
    pd.DataFrame([{"segundos_materializar": seg_tabla,
                   "tamano_archivo_gb": os.path.getsize(argumentos.db) / 1e9}]).to_csv(
        DOCS_DIR / "benchmark_tabla.csv", index=False)
    print("Resultados guardados en docs/benchmark.csv")


if __name__ == "__main__":
    main()
