# Python base image
FROM python:3.11-slim

WORKDIR /app

COPY app/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --upgrade setuptools==78.1.1
COPY app/ ./

EXPOSE 5000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
