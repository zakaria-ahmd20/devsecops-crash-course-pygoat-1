FROM python:3.11.0b1-buster

# Set work directory
WORKDIR /app

# Install dependencies for psycopg2
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    dnsutils \
    libpq-dev \
    python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install pip and Python dependencies
RUN python -m pip install --no-cache-dir pip==22.0.4
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app/

# Run Django migrations and start the application
EXPOSE 8000
RUN python3 /app/manage.py migrate
WORKDIR /app/pygoat/
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]

