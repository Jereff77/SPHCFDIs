# Usar Python 3.11 slim para producción
FROM python:3.11-slim

# Establecer directorio de trabajo
WORKDIR /app

# Configurar variables de entorno para Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

# Instalar dependencias del sistema necesarias
RUN apt-get update && apt-get install -y \
    gcc \
    libxml2-dev \
    libxslt-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Copiar y instalar dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copiar el código de la aplicación
COPY src/ ./src/
COPY main.py .
COPY config.py .

# Crear directorios necesarios
RUN mkdir -p logs .sessions

# Crear usuario no-root para seguridad
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app
USER appuser

# Exponer puerto (aunque no es necesario para este servicio)
EXPOSE 8000

# Comando por defecto para ejecución
CMD ["python", "main.py"]