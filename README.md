# Lab 8 - DuckDB

Laboratorio 8 del curso **CC3084 - Data Science**
(Universidad del Valle de Guatemala, Ciclo 2, 2026).

Equipo: Jose Lopez, Luis Palacios y Hugo Barillas.

Repositorio del equipo:

```bash
git clone https://github.com/JPLopez23/Lb8D.git
cd Lb8D
```

## Estructura

```text
duckdb/
|
+-- data/
|   +-- raw/
|   +-- processed/
|
+-- notebooks/
|
+-- scripts/
|
+-- sql/
|
+-- docs/
|
+-- Dockerfile
+-- metabase.Dockerfile
+-- docker-compose.yml
+-- README.md
```

## Requisitos

- Docker, con Docker Compose
- Git

La primera construccion del ambiente descarga varios cientos de MB y puede
tardar algunos minutos.

Considere el espacio en disco: las imagenes de Docker ocupan unos 3 GB y los
datos de los tres anios del laboratorio superan 1.5 GB, a los que se suma la
base materializada del Ejercicio 6. Se recomienda tener al menos 10 GB libres.

## Datos

El repositorio incluye `scripts/download_data.py`, que descarga los archivos de
taxis amarillos y verdes de 2024, 2025 y 2026 publicados por la TLC
(`--help` muestra las opciones disponibles). Los archivos se guardan en
`data/raw/<tipo>/<anio>/`.

La TLC publica cada mes con varias semanas de atraso, por lo que los ultimos
meses de 2026 todavia no existen. El script consulta al servidor que meses estan
publicados, de modo que vuelve a ejecutarse sin problema conforme aparezcan
nuevos archivos.

Los datos descargados **no deben incluirse en el repositorio Git**. El archivo
`.gitignore` ya esta configurado para evitarlo.

Fuente de datos: NYC TLC Trip Record Data
<https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page>

Dentro de los contenedores, la carpeta `data/` del proyecto esta montada en
`/workspace/data`. Esa es la ruta que deben usar las herramientas que corren
dentro del ambiente, no la ruta de su computadora.

> **Nota sobre DuckDB:** un archivo `.duckdb` admite un solo proceso con permiso
> de escritura a la vez. Si conecta una herramienta externa a su base de datos,
> use el modo de solo lectura (`read_only`) en esa conexion; de lo contrario los
> demas procesos no podran abrir el archivo.

## Material a entregar

Al finalizar, su fork debe contener:

- el codigo fuente modificado y los scripts de descarga;
- las consultas SQL desarrolladas;
- el notebook o notebooks utilizados;
- la documentacion de las consultas;
- los scripts utilizados para los benchmarks;
- el codigo de los indicadores y visualizaciones;
- el tablero o la evidencia del tablero desarrollado;
- este `README.md`, completado segun la siguiente seccion.

Los archivos de datos descargados **no** deben incluirse.

---

# Documentacion del equipo

Las siguientes secciones deben ser completadas por cada equipo. El README final
debe permitir que una persona que no participo en el desarrollo pueda levantar el
ambiente, descargar los datos, ejecutar el analisis, reproducir los benchmarks y
generar los resultados principales.

## Como levantar el ambiente

Requisitos: Docker con Docker Compose y Git. Se necesitan unos 10 GB libres en disco.

```bash
git clone https://github.com/JPLopez23/Lb8D.git
cd Lb8D
docker compose build lab
docker compose up -d lab
```

Despues abrir http://127.0.0.1:8888 para entrar a JupyterLab. El servicio metabase se construye con `docker compose build metabase` y `docker compose up -d metabase`, y queda en http://127.0.0.1:3000. Para apagar todo, `docker compose down`.

Para comprobar que el ambiente funciona:

```bash
docker compose ps
docker exec lab8-lab python -c "import duckdb; print(duckdb.__version__)"
```

Las versiones estan fijadas en requirements.txt para que todos obtengan los mismos resultados.

## Como descargar los datos

Desde la raiz del proyecto:

```bash
python scripts/download_data.py
```

Sin argumentos baja taxis amarillos y verdes de 2024, 2025 y 2026. Para un subconjunto:

```bash
python scripts/download_data.py --years 2026
python scripts/download_data.py --taxi yellow --years 2024 2025
```

Los archivos quedan en `data/raw/<tipo>/<anio>/`, por ejemplo `data/raw/yellow/2026/yellow_tripdata_2026-01.parquet`. Si el archivo ya existe y no esta vacio, el script lo omite. La descarga se escribe en un archivo temporal y solo se renombra al terminar.

Al final imprime un resumen. La descarga esta completa cuando `fallidos` e `incompletos` son 0. En 2024 y 2025 la TLC publica los doce meses. En 2026 el script solo baja los meses que el servidor ya tiene; los demas aparecen como `no publicados` y no son un error. Se puede volver a correr el script cuando salgan meses nuevos.

## Como ejecutar el analisis

Abrir `notebooks/Lab8_DuckDB.ipynb` en JupyterLab y ejecutar todas las celdas. Cada consulta esta en un archivo de la carpeta sql, con su objetivo y fuente al inicio, y el notebook la imprime y la ejecuta. Las consultas del notebook leen los archivos Parquet directamente, no hace falta importar nada.

Los archivos sql se leen con la ruta relativa de la carpeta notebooks, asi que el notebook debe ejecutarse desde ahi. Si la maquina tiene poca memoria, el notebook limita DuckDB a 1.5 GB y 2 hilos.

## Como reproducir los benchmarks

```bash
cd notebooks
python ../scripts/benchmark.py
```

El script crea la tabla viajes_tabla en data/processed/lab8.duckdb, cargandola mes por mes, corre las seis consultas de sql 06_bench con Parquet y con la tabla, con cuatro cantidades de datos y tres repeticiones, y guarda los tiempos en docs/benchmark.csv. Crear la tabla tarda cerca de 13 minutos y el archivo ocupa unos 2.8 GB. Se puede cambiar la ubicacion con la variable LAB8_DB, y la carpeta temporal con LAB8_TEMP.

## Como generar los resultados principales

Las tablas y graficas quedan en la carpeta docs al ejecutar el notebook: tablero.png con los nueve indicadores, benchmark.png y benchmark.csv con los tiempos, evolucion_3_anios.png con la comparacion de los tres anios y las graficas del analisis exploratorio.

El tablero del laboratorio esta en Metabase. Despues de crear `data/processed/lab8.duckdb` con el benchmark:

```bash
docker compose build metabase
docker compose up -d metabase
```

Abrir http://127.0.0.1:3000, crear la cuenta de administrador y agregar una base DuckDB con la ruta `/workspace/data/processed/lab8.duckdb` en modo de solo lectura. Las preguntas del tablero usan las consultas `sql/07_ind1` a `sql/07_ind9`, cambiando la vista `viajes` por la tabla `viajes_tabla`. La captura del tablero esta en `docs/tablero_metabase.png`.
