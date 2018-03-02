# These are prep steps that need to be carried out in the compute / running / serving instance
# carry out at the home directory

# copy the secrets
export SECRETS_DIR=$HOME/Projects/kbs_docker &&
cp SECRETS_DIR/.env . &&
cp SECRETS_DIR/backend/env.list .



git clone https://github.com/trong-nguyen/kbs_docker.git

# cloning the repo on compute instance, make sure that the KEY and SECRET present in the env
REPO=kbs_backend &&
REPO_URL=bitbucket.org/trong2nguyen/$REPO.git &&
git clone "https://x-token-auth:$(curl -X POST -u "$BITBUCKET_KEY:$BITBUCKET_SECRET" https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials | python -c "import sys, json; print json.load(sys.stdin)['access_token']")@$REPO_URL" $REPO \
&& cd $REPO && git checkout master && cd ..

# copy the env .var to machine
gcloud compute scp ~/Projects/kbs_docker/.env instance-2:~/kbs_docker/

# install docker-compose
# https://cloud.google.com/community/tutorials/docker-compose-on-container-optimized-os
docker run docker/compose:1.13.0 version
# alias to bashrc
echo alias docker-compose="'"'docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:/rootfs/$PWD" \
    -w="/rootfs/$PWD" \
    docker/compose:1.13.0'"'" >> ~/.bashrc
source ~/.bashrc

# up we go
docker-compose up

# rootfs