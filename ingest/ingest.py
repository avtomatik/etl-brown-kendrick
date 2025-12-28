import io
import tempfile
import zipfile
from pathlib import Path

import duckdb
import yaml

from ingest.config import SOURCES_YAML, WAREHOUSE


def load_config():
    with SOURCES_YAML.open(encoding="utf-8") as f:
        return yaml.safe_load(f)["sources"]


def ensure_schema(con):
    con.execute("CREATE SCHEMA IF NOT EXISTS raw")


def ingest_file(con: duckdb.DuckDBPyConnection, cfg: dict) -> None:
    zip_path = Path(cfg["path"])
    data_file = cfg["data_file"]
    columns = ", ".join(cfg["columns"])

    with zipfile.ZipFile(zip_path, "r") as archive:
        with archive.open(data_file) as json_file:
            file_buffer = io.BytesIO(json_file.read())

            with tempfile.NamedTemporaryFile(
                delete=False, suffix=".json.gz"
            ) as tmp_file:
                tmp_file.write(file_buffer.getvalue())
                tmp_file_path = tmp_file.name

            con.execute(
                f"""
            CREATE OR REPLACE TABLE raw.{zip_path.stem} AS
            SELECT {columns}
            FROM read_json_auto('{tmp_file_path}')
        """
            )


def ingest_all(only: str | None = None):
    cfg = load_config()
    con = duckdb.connect(WAREHOUSE)
    ensure_schema(con)

    for name, data_config in cfg.items():
        if only and name != only:
            continue

        print(f"Ingesting {name}...")

        ingest_file(con, data_config)

    con.close()
    print(f"Ingestion Complete.")
