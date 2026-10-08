# Lab 8 - DuckDB

Repositorio base del laboratorio 8 del curso **CC3084 - Data Science**
(Universidad del Valle de Guatemala, Ciclo 2, 2026).

Este es el repositorio **proporcionado por el docente**. Contiene la estructura
del proyecto, el ambiente de ejecucion basado en Docker y un script que descarga
los datos de **2026**. Todo lo demas debe ser construido por cada equipo.

## Trabajo con fork

El laboratorio se desarrolla y se entrega sobre un **fork** de este repositorio.
No se trabaja directamente sobre el repositorio del docente.

1. Realice un fork de este repositorio:
   <https://github.com/menene/duckdb>

2. Clone **su propio fork** (no el del docente):

   ```bash
   git clone https://github.com/<su-usuario>/duckdb.git
   cd duckdb
   ```

3. Opcional, para recibir correcciones publicadas por el docente:

   ```bash
   git remote add upstream https://github.com/menene/duckdb.git
   git fetch upstream
   ```

Realice commits frecuentes y descriptivos: el historial del repositorio es parte
de la evaluacion. **La entrega del laboratorio es la URL de su fork.**

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
2026 publicados por la TLC (`--help` muestra las opciones disponibles). Los
archivos se guardan en `data/raw/<tipo>/<anio>/`.

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
git clone https://github.com/<su-usuario>/duckdb.git
cd duckdb
docker compose build lab
docker compose up -d lab
```

Despues abrir http://127.0.0.1:8888 para entrar a JupyterLab. El servicio metabase se construye con `docker compose build metabase` y queda en http://127.0.0.1:3000. Para apagar todo, `docker compose down`.

Para comprobar que el ambiente funciona:

```bash
docker compose ps
docker exec lab8-lab python -c "import duckdb; print(duckdb.__version__)"
```

Las versiones estan fijadas en requirements.txt para que todos obtengan los mismos resultados.

## Como descargar los datos



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

Las tablas y graficas quedan en la carpeta docs al ejecutar el notebook: tablero.png con los nueve indicadores, benchmark.png y benchmark.csv con los tiempos, evolucion_3_anios.png con la comparacion de los tres anios y las graficas del analisis exploratorio. Las consultas de cada indicador estan en sql con prefijo 07_ind y pueden usarse para armar el tablero en Metabase, conectando la base data/processed/lab8.duckdb en modo de solo lectura.

Nota sobre este entregable. El tablero de esta entrega es una figura generada con Python porque Metabase no se pudo construir en la maquina de desarrollo por falta de espacio en disco.
