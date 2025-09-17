"""# Use official Python base image
FROM python:3.10-slim

# Set working directory inside the container
WORKDIR /app

# Copy requirements file if you have one
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files (app.py, agent.py, ui.py, etc.)
COPY . .

# Expose Streamlit default port
EXPOSE 8501

# Healthcheck endpoint provided by Streamlit
HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health || exit 1
"""
# Run Streamlit app
#CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]

# Stage 1: Build stage
FROM python:3.10-slim AS builder
WORKDIR /app

# Install pip dependencies in one layer to avoid cache bloat
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --prefix=/install -r requirements.txt \
    && rm -rf /root/.cache/pip

# Stage 2: Runtime stage
FROM python:3.10-slim
WORKDIR /app

# Copy only installed packages
COPY --from=builder /install /usr/local
# Copy only application code (ignore data, tests, etc.)
COPY . .

# Expose streamlit port
EXPOSE 8501

# Run app
CMD ["streamlit", "run", "app.py"]