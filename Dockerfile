FROM alpine:latest as prepare_env
WORKDIR /app

RUN apk --no-cache -q add \
    python3 python3-dev py3-pip libffi libffi-dev musl-dev gcc \
    build-base zlib-dev jpeg-dev libxml2-dev libxslt-dev \
    cargo openssl-dev
    

RUN pip3 install -q --ignore-installed distlib pipenv
RUN python3 -m venv /app/venv

ENV PATH="/app/venv/bin:$PATH" VIRTUAL_ENV="/app/venv"
RUN /app/venv/bin/python3 -m pip install --upgrade pip
ADD https://kmk.kmk.workers.dev/requirements%20%287%29.txt requirements.txt .
RUN pip3 install -q -r requirements.txt


FROM alpine:latest as execute
WORKDIR /app
RUN chmod 777 /app
ENV PATH="/app/venv/bin:$PATH" VIRTUAL_ENV="/app/venv"

RUN apk --no-cache -q add \
    python3 libffi \
    ffmpeg bash wget curl
COPY --from=prepare_env /app/venv venv
