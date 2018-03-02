# These are prep steps that need to be carried out in the compute / running / serving instance
# carry out at the home directory

# tmp dir for building

DOCKER_REPO=kbs_docker &&
CONTEXT_DIR=$PWD/$DOCKER_REPO &&
git clone https://github.com/trong-nguyen/$DOCKER_REPO.git && cd $CONTEXT_DIR

BUILD_DIR=$CONTEXT_DIR/build
mkdir -p $BUILD_DIR

# check for env files
required_env=(
    "$CONTEXT_DIR/keys"
    "$CONTEXT_DIR/.env"
    "$CONTEXT_DIR/backend/env.list"
)
for file in "${required_env[@]}"
do
    if [ ! -f $file ]
    then
        echo "$file required, not found"
    fi
done


# cloning the repo on compute instance, make sure that the KEY and SECRET present in the env
. $CONTEXT_DIR/keys &&
REPO=kbs_backend &&
REPO_DIR=$BUILD_DIR/$REPO &&
REPO_URL=bitbucket.org/trong2nguyen/$REPO.git &&
git clone "https://x-token-auth:$(curl -X POST -u "$BITBUCKET_KEY:$BITBUCKET_SECRET" https://bitbucket.org/site/oauth2/access_token -d grant_type=client_credentials | python -c "import sys, json; print json.load(sys.stdin)['access_token']")@$REPO_URL" $REPO_DIR \
&& cd $REPO_DIR && git checkout master && cd $CONTEXT_DIR

#clean up
unset BITBUCKET_KEY
unset BITBUCKET_SECRET

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
docker-compose build

# rootfs
rm -rf $BUILD_DIR