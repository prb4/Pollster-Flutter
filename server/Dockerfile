FROM python:3.10.11-bullseye

RUN mkdir /app
WORKDIR /app

COPY . .
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "./app.py"]
