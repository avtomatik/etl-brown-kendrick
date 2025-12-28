# fuse_usa_brown_kendrick

Data Fusion from M.G. Brown & J.W. Kendrick Sources.

```bash
$ uv venv --python 3.12
$ source .venv/bin/activate
$ uv sync
$ uv run python -m ingest.cli
$ uv run dbt run --project-dir dbt
$ duckdb duckdb/warehouse.duckdb
$ D SELECT * FROM usa_brown_kendrick;  # << Your Final Table Here
$ D .exit
```
---
