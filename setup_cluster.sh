git clone https://github.com/trong-nguyen/kbs_docker.git

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