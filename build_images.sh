ROOT=$PWD

cd $ROOT/backend && . setup_build.sh
cd $ROOT/news && . setup_build.sh

cd $ROOT &&
docker-compose build &&

PROJECT=web-host-196219
HOST_REGION=us.gcr.io

# tag and push to google cloud registry

gcloud docker -- push $HOST_REGION/$PROJECT/kbs_backend

gcloud docker -- push $HOST_REGION/$PROJECT/kbs_news

cd $ROOT