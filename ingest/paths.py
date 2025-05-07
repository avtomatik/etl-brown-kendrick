from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[1]

WAREHOUSE_DIR = BASE_DIR / "data" / "processed" / "warehouse.duckdb"
SOURCES_PATH = BASE_DIR / "ingest" / "sources.yml"
