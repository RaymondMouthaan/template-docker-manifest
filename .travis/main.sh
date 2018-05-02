#!/bin/bash

set -o errexit

main() {
  setup_dependencies
  update_docker_configuration

  echo "SUCCESS:
  Done! Finished setting up travis machine.
  "
}

setup_dependencies() {
  echo "INFO:
  Setting up dependencies.
  "

  sudo apt update -y
  sudo apt install realpath python python-pip -y
  sudo apt install --only-upgrade docker-ce -y
  sudo pip install docker-compose || true

  # Get qemu-arm-static binary
  mkdir tmp
  pushd tmp &&
  curl -L -o qemu-arm-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/v2.9.1-1/qemu-arm-static.tar.gz &&
  tar xzf qemu-arm-static.tar.gz &&
  curl -L -o qemu-aarch64-static.tar.gz https://github.com/multiarch/qemu-user-static/releases/download/v2.9.1-1/qemu-aarch64-static.tar.gz &&
  tar xzf qemu-aarch64-static.tar.gz &&
  popd

  docker info
  docker-compose --version
}

update_docker_configuration() {
  echo "INFO:
  Updating docker configuration
  "

  echo '{
  "experimental": true,
  "storage-driver": "overlay2",
  "max-concurrent-downloads": 50,
  "max-concurrent-uploads": 50
}' | sudo tee /etc/docker/daemon.json
  sudo service docker restart
}

main
