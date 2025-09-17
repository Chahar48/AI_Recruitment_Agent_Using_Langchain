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

# Stage 1: build stage
FROM python:3.10-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

# Stage 2: runtime stage
FROM python:3.10-slim
WORKDIR /app
COPY --from=builder /install /usr/local
COPY . .
CMD ["streamlit", "run", "app.py"]