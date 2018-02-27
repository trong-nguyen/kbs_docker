FROM python:2.7
#ENV PYTHONUNBUFFERED 1
#ENV DEBIAN_FRONTEND noninteractive

# declare key and secret pair to clone repos, passed from --build-arg
ARG BITBUCKET_KEY
ARG BITBUCKET_SECRET

RUN apt-get update && apt-get install -y \
    gcc g++ \
    sqlite3 libsqlite3-dev \
    libjpeg-dev zlib1g-dev

# clone the private repo with secrets loaded from build-arg
RUN git clone "https://x-token-auth:$(curl -X POST -u "$BITBUCKET_KEY:$BITBUCKET_SECRET" https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials | python -c "import sys, json; print json.load(sys.stdin)['access_token']")@bitbucket.org/trong2nguyen/kbs_backend.git" && cd kbs_backend && git checkout master && cd ..


RUN cp -R /kbs_backend /home/app
#RUN chown app:app -R /home/app
RUN pip install -r /home/app/requirements.txt


# Clean-up
RUN apt-get clean && rm -rf /kbs_backend/