commit=$(git rev-list -n 1 stable)
echo ${commit}
mkdir tmp
cp Georgia-Dockerfile tmp/
cp config.yml tmp/
cp .dockerignore tmp/
mv tmp/Georgia-Dockerfile .
mv tmp/config.yml .
mv tmp/.dockerignore .
rm -r tmp
docker build --pull -f Georgia-Dockerfile -t ctriley/graphhopper-georgia:latest .
docker push ctriley/graphhopper-georgia:latest
az acr login --name dispatchingcr
docker tag ctriley/graphhopper-georgia:latest dispatchingcr.azurecr.io/graphhopper:latest
docker push dispatchingcr.azurecr.io/graphhopper:latest

