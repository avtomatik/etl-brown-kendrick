# etl-brown-kendrick

**ETL Pipeline for Data Fusion: M.G. Brown & J.W. Kendrick Macroeconomic Sources**

This project automates the ingestion, transformation, and fusion of historical macroeconomic data from **M.G. Brown** and **J.W. Kendrick** sources into a **DuckDB warehouse**. The final table, `usa_brown_kendrick`, contains fused, processed data ready for analysis.

### Prerequisites

Ensure you have the following installed:

* **Python 3.12+**
* **DuckDB** (used as the data warehouse)
* **DBT (Data Build Tool)**

### Setup & Installation

1. **Create a virtual environment**:

   ```bash
   $ uv venv --python 3.12
   ```

2. **Activate the virtual environment**:

   ```bash
   $ source .venv/bin/activate
   ```

3. **Install dependencies**:

   ```bash
   $ uv sync
   ```

4. **Ingest raw data into DuckDB**:
   This step fetches and ingests raw data from the M.G. Brown and J.W. Kendrick sources.

   ```bash
   $ uv run python -m ingest.cli
   ```

5. **Run DBT transformations**:
   This step runs the data transformations, creating models from the raw data and applying the necessary business logic.

   ```bash
   $ uv run dbt run --project-dir dbt
   ```

6. **Access the DuckDB warehouse**:
   Open the DuckDB CLI to explore your data:

   ```bash
   $ duckdb data/processed/warehouse.duckdb
   ```

7. **Query the final table**:
   To view your final fused dataset (`usa_brown_kendrick`), run the following SQL:

   ```sql
   D SELECT * FROM usa_brown_kendrick;  # << Your Final Table Here
   ```

8. **Exit DuckDB**:

   ```bash
   D .exit
   ```

### Directory Structure

```bash
etl-brown-kendrick/
├── dbt/                     # dbt models and configurations
│   ├── dbt_project.yml      # dbt project configuration
│   ├── profiles.yml         # dbt profile for DuckDB
│   └── models/              # dbt models (staging, intermediate, marts)
├── ingest/                  # Data ingestion scripts
│   └── cli.py               # Command-line interface for data ingestion
├── data/
|   └── processed/           # DuckDB warehouse
│       └── warehouse.duckdb # Your final DuckDB database
└── .venv/                   # Virtual environment
```

### How It Works

1. **Ingestion**: Raw data is downloaded from **M.G. Brown** and **J.W. Kendrick** sources. This step processes the data into intermediate formats that are suitable for analysis.

2. **DBT Transformation**:

   * The DBT models transform the raw data into intermediate formats, applying necessary business logic (e.g., merging series, calculations).
   * The final model (`usa_brown_kendrick`) is created in **marts/** and is **incrementally built** for efficiency.

3. **DuckDB Warehouse**: The final fused dataset is stored in a **DuckDB database** (`warehouse.duckdb`) and can be queried using SQL.

---

### Configuration

**Profiles**:
The project requires a **DBT profile** configured for DuckDB. The profile is located in `~/.dbt/profiles.yml` and should look like this:

```yaml
etl_brown_kendrick:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: ./data/processed/warehouse.duckdb
```

This configuration tells DBT how to connect to the **DuckDB warehouse**.

---

### Data Pipeline Overview

1. **Ingestion**:

   * Raw data is fetched using the `ingest.cli` script.

2. **DBT Transformations**:

   * Data transformations are managed by DBT models.
   * Models are organized into:

     * **staging**: Raw, minimally transformed data
     * **intermediate**: Aggregated data
     * **marts**: Final, analysis-ready tables (fused Brown & Kendrick data)

3. **Final Table**:
   The final **`usa_brown_kendrick`** table contains the fused data, ready for analysis in **DuckDB**.

---

### Testing and Debugging

To test your project or debug issues, use DBT's built-in commands:

* **Run DBT Debug**: Verify that your DBT configuration is correct:


  ```bash
  $ uv run dbt debug --project-dir dbt
  ```

* **Show All Deprecations**: If you encounter any deprecation warnings, you can see a full list by running:

  ```bash
  $ uv run dbt run --project-dir dbt --show-all-deprecations
  ```

---

### Notes

* **Incremental Models**: The final model `usa_brown_kendrick` is incremental, meaning it only processes new data since the last run, making it more efficient.
* **Rounding**: In the final mart, rounding is applied to certain columns (e.g., `brown_0x0`, `brown_0x1`), ensuring the final dataset is suitable for reporting or analysis.

---

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
