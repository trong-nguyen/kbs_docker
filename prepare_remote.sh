# These are prep steps that need to be carried out in the compute / running / serving instance
# carry out at the home directory

# tmp dir for building

# DOCKER_REPO=kbs_docker &&
# CONTEXT_DIR=$PWD/$DOCKER_REPO &&
# git clone https://github.com/trong-nguyen/$DOCKER_REPO.git && cd $CONTEXT_DIR

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
        exit 0
    fi
done


mkdir -p deploy
cp -rf backend webserver .env keys prepare_host.sh deploy
cp -f docker-compose.prod.yml deploy/docker-compose.yml

gcloud compute scp --compress --recurse $PWD/deploy/. instance-3:~/app

#gcloud docker -- push us.gcr.io/web-host-196219/kbsdocker_backend:latest
# docker-credential-gcr configure-docker