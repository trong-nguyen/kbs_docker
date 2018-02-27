FROM python:3
ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -yq install gcc g++ && \
    apt-get -yq install sqlite3 libsqlite3-dev && \
    apt-get -yq install libjpeg-dev zlib1g-dev && \
    apt-get -yq git && \
    apt-get -yq python-pip && \

RUN BITBUCKET_KEY=cTweV4WAw8PaCVk5Sg && BITBUCKET_SECRET=WTdBVsNyer7UWWAbfHMC7ZT3euwKu2NK && git clone "https://x-token-auth:$(curl -X POST -u "$BITBUCKET_KEY:$BITBUCKET_SECRET" https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials | python -c "import sys, json; print json.load(sys.stdin)['access_token']")@bitbucket.org/trong2nguyen/kbs_backend.git" && cd kbs_backend && git checkout master && cd ..

RUN cp -R /kbs_backend /
RUN pip install -r kbs_backend/requirements.txt
