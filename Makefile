IMAGE := docker-manifest-arm-linux
VERSION := v1.2.3

test:
  true

# Build image
build-image:
  docker build --file Dockerfile.linux-arm32v6 --tag $(IMAGE):linux-arm-latest .

# Tag image
tag-image:
  docker tag $(IMAGE):linux-arm-latest ${IMG_NAME}:linux-arm-$(VERSION)

# Push image
push-image:
  docker push $(IMAGE):linux-arm-latest
  docker push $(IMAGE):linux-arm-$(VERSION)

manifest-list-image:
  # Create manifest for the version tag
  docker manifest create "$(IMG_NAME):$(VERSION)" \
    "$(IMG_NAME):linux-arm-$(VERSION)"
    
  # Set the architecture to ARM for the ARM image
  docker manifest annotate "$(IMG_NAME):$(VERSION)" "$(IMG_NAME):linux-arm-$(VERSION)" --os=linux --arch=arm --variant=v6

  # Push the manifest
  docker manifest push "$(IMG_NAME):$(VERSION)"

  # Repeat for the latest tag
  docker manifest create "$(IMG_NAME):latest" \
    "${IMG_NAME}:linux-arm-latest"
  docker manifest annotate "$(IMG_NAME):latest" "$(IMG_NAME):linux-arm-latest" --os=linux --arch=arm --variant=v6
  docker manifest push "$(IMG_NAME):latest"

.PHONY: image push-image test
