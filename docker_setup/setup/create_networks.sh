#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
    echo "docker command not found" >&2
    exit 1
fi

user=$(id -un)
if [ "$(id -u)" -eq 0 ] || id -nG "$user" 2>/dev/null | grep -qw docker; then
    DOCKER_CMD="docker"
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "sudo required but not found; add $user to the docker group or install sudo" >&2
        exit 1
    fi
    DOCKER_CMD="sudo docker"
fi

# Create cust_traefik if it doesn't exist
if ! $DOCKER_CMD network inspect cust_traefik >/dev/null 2>&1; then
    $DOCKER_CMD network create \
        --driver=bridge \
        --internal \
        --subnet=172.30.0.0/24 \
        --gateway=172.30.0.1 \
        cust_traefik
fi

# Create net_access if it doesn't exist
if ! $DOCKER_CMD network inspect net_access >/dev/null 2>&1; then
    $DOCKER_CMD network create net_access
fi
