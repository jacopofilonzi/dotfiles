mkdir data
touch data/acme.json
chmod 600 data/acme.json

cp .env.example .env

if id -nG "${USER:-$(whoami)}" | grep -qw docker; then
    DOCKER_CMD=docker
else
    DOCKER_CMD="sudo docker"
fi

$DOCKER_CMD network create \
    --driver=bridge \
    --internal \
    --subnet=172.30.0.0/24 \
    --gateway=172.30.0.1 \
    cust_traefik