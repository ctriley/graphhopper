#!/bin/bash

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-$1} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

build_containers() {
    docker build . --no-cache -t graphhopper:latest
}

commit_to_azure() {
    docker tag graphhopper:latest ai4optgraphhopper.azurecr.io/graphhopper:latest
   
    #push images
    docker push ai4optgraphhopper.azurecr.io/graphhopper:latest
}

SKIP_VERIFICATION=false

while [ "$1" != "" ]; do
    case $1 in
    --skip-verification)
        SKIP_VERIFICATION=true
        ;;
    esac
    shift
done

#az login
az acr login --name ai4optgraphhopper
if ${SKIP_VERIFICATION}; then
    build_containers
else 
    confirm "Do you want to build containers?" && build_containers
fi

commit_to_azure




