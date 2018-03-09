# install docker-compose
# https://cloud.google.com/community/tutorials/docker-compose-on-container-optimized-os
docker-credential-gcr configure-docker


docker run docker/compose:1.13.0 version
# alias to bashrc
echo alias docker-compose="'"'docker run \
    -e WORKING_DIR=$PWD \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:/rootfs/$PWD" \
    -w="/rootfs/$PWD" \
    docker/compose:1.13.0'"'" >> ~/.bashrc
source ~/.bashrc

# up we go
docker-compose up


gcloud docker -- push us.gcr.io/web-host-196219/kbsdocker_backend:latest