IMAGE := docker-manifest-arm-linux
VERSION := v1.2.3

test:
	true

build-image:
	docker build --file Dockerfile.linux-arm32v6 --tag $(IMAGE):linux-arm-latest .

tag-image:
	docker tag $(IMAGE):linux-arm-latest ${IMG_NAME}:linux-arm-$(VERSION)

push-image:
	docker push $(IMAGE):linux-arm-latest
	docker push $(IMAGE):linux-arm-$(VERSION)

manifest-list-image:
	docker manifest create "$(IMG_NAME):$(VERSION)" \
	"$(IMG_NAME):linux-arm-$(VERSION)"
	docker manifest annotate "$(IMG_NAME):$(VERSION)" "$(IMG_NAME):linux-arm-$(VERSION)" --os=linux --arch=arm --variant=v6
	docker manifest push "$(IMG_NAME):$(VERSION)"
	docker manifest create "$(IMG_NAME):latest" \
	"${IMG_NAME}:linux-arm-latest"
	docker manifest annotate "$(IMG_NAME):latest" "$(IMG_NAME):linux-arm-latest" --os=linux --arch=arm --variant=v6
	docker manifest push "$(IMG_NAME):latest"

.PHONY: image push-image test
