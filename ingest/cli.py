import argparse

from ingest import ingest_all


def main():
    parser = argparse.ArgumentParser(
        description="Ingest raw datasets into DuckDB"
    )
    parser.add_argument(
        "--source", help="Ingest only a specific source", required=False
    )

    args = parser.parse_args()
    ingest_all(only=args.source)


if __name__ == "__main__":
    main()
