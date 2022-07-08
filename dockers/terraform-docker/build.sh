set -ex

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=midockerdb
# image name
IMAGE=rapture:packer-controller

docker build -t $USERNAME/$IMAGE:latest .
