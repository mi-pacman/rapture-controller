set -ex

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=midockerdb
# image name
IMAGE=rapture:packer-controller

# ensure we're up to date
git pull

# bump version
docker run --rm -v "$PWD":/app midockerdb/bump patch
version=`cat VERSION`
echo "version: $version"

# run build
./build.sh

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tagsdocker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version

# push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version
