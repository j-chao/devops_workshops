FROM python:2.7.16-alpine
LABEL maintainer Justin Chao
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python", "app.py"]
