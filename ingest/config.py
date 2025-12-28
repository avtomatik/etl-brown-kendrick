from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

WAREHOUSE = BASE_DIR / "duckdb" / "warehouse.duckdb"
SOURCES_YAML = BASE_DIR / "ingest" / "sources.yml"
