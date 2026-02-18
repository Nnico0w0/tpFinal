# Dockerfile para Django Backend
FROM python:3.9-slim

# Variables de entorno
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        gcc \
        python3-dev \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copiar y instalar dependencias de Python
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copiar código del proyecto
COPY . /app/

# Crear directorio para archivos estáticos y media
RUN mkdir -p /app/staticfiles
RUN mkdir -p /app/media

# Make entrypoint script executable
RUN chmod +x /app/docker-entrypoint.sh

# Exponer puerto
EXPOSE 8000

# Set entrypoint
ENTRYPOINT ["/app/docker-entrypoint.sh"]

# Script de inicio
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]