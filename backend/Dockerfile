FROM python:2.7-slim
ENV PYTHONUNBUFFERED 1

# name of the backend repo, i.e. kbs_backend
ARG APP_DIR=/home/app
ARG CODE=build/kbs_backend

ARG RUNTIME_PACKAGES="sqlite3 libsqlite3-dev libjpeg-dev zlib1g-dev"
ARG BUILD_PACKAGES="gcc"

# install dependencies and immediately remove to save image size
# MAKE ABSOLUTELY sure that you remove BUILD_PACKAGES after installing requirements.txt

ADD $CODE $APP_DIR
RUN apt-get update && apt-get install -y \
        $RUNTIME_PACKAGES \
        $BUILD_PACKAGES \
    && pip install --no-cache-dir -r $APP_DIR/requirements.txt \
    && apt-get remove -y $BUILD_PACKAGES \
    && apt-get autoremove -y \
    && apt-get clean

# Clean-up
WORKDIR $APP_DIR

# Setup the server
# done in compose
# EXPOSE 8000

# running task, remember to set WORKDIR properly
CMD ["uwsgi", "--ini", "kbs_backend/uwsgi.ini", "--http-auto-chunked", "--http-keepalive"]
