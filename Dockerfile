FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /docker_app

COPY requirements.txt /docker_app/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /docker_app/

EXPOSE 8000

ENTRYPOINT [ "python" ] 

CMD ["manage.py", "runserver", "0.0.0.0:8000"]