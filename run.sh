CONTAINER_NAME="kbs_container" && \
docker run --name $CONTAINER_NAME -p 80:80 -d --env-file ./env.list kbs_backend:source && \
docker exec -di $CONTAINER_NAME /etc/init.d/nginx restart