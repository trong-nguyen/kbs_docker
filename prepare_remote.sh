# These are prep steps that need to be carried out in the compute / running / serving instance
# carry out at the home directory

# tmp dir for building

# DOCKER_REPO=kbs_docker &&
# CONTEXT_DIR=$PWD/$DOCKER_REPO &&
# git clone https://github.com/trong-nguyen/$DOCKER_REPO.git && cd $CONTEXT_DIR

# check for env files
CONTEXT_DIR=$PWD
required_env=(
    "$CONTEXT_DIR/keys"
    "$CONTEXT_DIR/.env"
    "$CONTEXT_DIR/backend/env.list"
    "$CONTEXT_DIR/news/env.list"
)
for file in "${required_env[@]}"
do
    if [ ! -f $file ]
    then
        echo "$file required, not found"
        # exit 0
    fi
done


rm -rf deploy
mkdir -p deploy
cp -rf backend webserver .env prepare_host.sh deploy
cp -f docker-compose.* deploy/

#news
DB_DIR=news/persistent/db/data
mkdir -p deploy/$DB_DIR
cp $DB_DIR/ghost.db deploy/$DB_DIR
cd news && tar -zvcf ghost.zip ghost && mv ghost.zip $CONTEXT_DIR/deploy/news
cd $CONTEXT_DIR

INSTANCE_NAME=instance-4
gcloud compute scp --compress --recurse $PWD/deploy/. $INSTANCE_NAME:~/app