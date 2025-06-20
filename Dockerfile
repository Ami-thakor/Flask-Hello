# Base image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project files
COPY . .

# Collect static files
# Collect static files (templates are used at runtime, no need to compile them)
RUN python manage.py collectstatic --noinput
# Expose port
EXPOSE 5500

# Run the app using Gunicorn
CMD ["gunicorn", "mysite.wsgi:application", "--bind", "0.0.0.0:5500", "--workers", "3"]
