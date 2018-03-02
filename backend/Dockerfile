FROM python:2.7-slim
ENV PYTHONUNBUFFERED 1

# declare key and secret pair to clone repos, passed from --build-arg
ARG REPO_KEY
ARG REPO_SECRET

ARG APP_DIR=/home/app
ARG REPO_URL=bitbucket.org/trong2nguyen/kbs_backend.git

ARG RUNTIME_PACKAGES="sqlite3 libsqlite3-dev libjpeg-dev zlib1g-dev"
ARG BUILD_PACKAGES="git curl gcc g++ build-essential"

# install dependencies and immediately remove to save image size
# MAKE ABSOLUTELY sure that you remove BUILD_PACKAGES after installing requirements.txt
RUN apt-get update && apt-get install -y \
    $RUNTIME_PACKAGES \
    $BUILD_PACKAGES \
&& git clone "https://x-token-auth:$(curl -X POST -u "$REPO_KEY:$REPO_SECRET" https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials | python -c "import sys, json; print json.load(sys.stdin)['access_token']")@$REPO_URL" \
&& cd kbs_backend && git checkout master && cd .. \
&& cp -r /kbs_backend $APP_DIR \
&& pip install --no-cache-dir -r $APP_DIR/requirements.txt \
&& apt-get remove -y $BUILD_PACKAGES \
&& apt-get autoremove -y \
&& apt-get clean && rm -rf /kbs_backend

# Clean-up
WORKDIR $APP_DIR

# Setup the server
# done in compose
# EXPOSE 8000

# running task, remember to set WORKDIR properly
CMD ["uwsgi", "--ini", "kbs_backend/uwsgi.ini", "--http-auto-chunked", "--http-keepalive"]
