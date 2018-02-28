FROM python:2.7
#ENV PYTHONUNBUFFERED 1
#ENV DEBIAN_FRONTEND noninteractive

# declare key and secret pair to clone repos, passed from --build-arg
ARG REPO_KEY
ARG REPO_SECRET

ARG APP_DIR=/home/app
ARG REPO_URL=bitbucket.org/trong2nguyen/kbs_backend.git

RUN apt-get update && apt-get install -y \
    sqlite3 libsqlite3-dev \
    libjpeg-dev zlib1g-dev

# clone the private repo with secrets loaded from build-arg
RUN git clone "https://x-token-auth:$(curl -X POST -u "$REPO_KEY:$REPO_SECRET" https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials | python -c "import sys, json; print json.load(sys.stdin)['access_token']")@$REPO_URL" && cd kbs_backend && git checkout master && cd ..
COPY kbs_backend $APP_DIR

# dev using current folder
RUN pip install --no-cache-dir -r $APP_DIR/requirements.txt

# Clean-up
RUN apt-get clean && rm -rf /kbs_backend/

WORKDIR $APP_DIR

# Setup the server
EXPOSE 8000

# running task, remember to set WORKDIR properly
CMD ["uwsgi", "--ini", "kbs_backend/uwsgi.ini", "--http-auto-chunked", "--http-keepalive"]
