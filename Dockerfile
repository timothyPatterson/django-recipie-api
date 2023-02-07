FROM python:3.9-alpine3.13
LABEL maintainer="tp"

# prevent buffering of logs to terminal - i.e. display immediatly
ENV PYTHONUNBUFFERED 1

# copy requirements.txt from local machine to /tmp
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app app
# all commands run from /app directory
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip \ 
    && /py/bin/pip install -r /tmp/requirements.txt && \
    # ** shell script **
    if [ $DEV = "true"]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    # ***********
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user