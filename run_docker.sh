CONTAINER_NAME=${CONTAINER_NAME:-"kbs_container"} && \
docker run --name $CONTAINER_NAME -p 80:8000 -d --env-file ./env.list kbs_backend:latest