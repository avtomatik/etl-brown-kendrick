 # Use official Python 3.12 image
FROM python:3.12-trixie

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Install `uv`
RUN pip install uv

# Install DuckDB using the official installation script
RUN curl https://install.duckdb.org | sh

# Ensure DuckDB is in the PATH
RUN echo "export PATH=\$PATH:/usr/local/bin" >> ~/.bashrc

# Copy project metadata for dependency installation
COPY pyproject.toml uv.lock* /app/

# Create a virtual environment using `uv`
RUN uv venv --python 3.12

# Install dependencies using `uv`
RUN bash -c "source .venv/bin/activate && uv sync"

# Copy the rest of the project files into the container
COPY dbt /app/dbt
COPY ingest /app/ingest
COPY data /app/data
COPY dbt_profiles /app/dbt_profiles

# Set environment variable for DBT profiles location
ENV DBT_PROFILES_DIR=/app/dbt_profiles

# Set entrypoint to bash for interactive commands
ENTRYPOINT ["/bin/bash"]
