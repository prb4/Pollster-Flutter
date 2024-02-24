FROM python:3.10-alpine

RUN mkdir /app
WORKDIR /app

COPY ./requirements.txt . 
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["python", "./app.py"]
