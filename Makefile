IMAGE := raymondmm/docker-manifest
VERSION := v1.2.3

test:
	true

build-image:
	docker build --file Dockerfile.linux-arm32v6 --tag $(IMAGE):linux-arm-latest .

tag-image:
	docker tag $(IMAGE):linux-arm-latest $(IMAGE):linux-arm-$(VERSION)

push-image:
	docker push $(IMAGE):linux-arm-latest
	docker push $(IMAGE):linux-arm-$(VERSION)

manifest-list-image:
	docker manifest create "$(IMAGE):$(VERSION)" \
		"$(IMAGE):linux-arm-$(VERSION)"
	docker manifest annotate "$(IMAGE):$(VERSION)" "$(IMAGE):linux-arm-$(VERSION)" --os=linux --arch=arm --variant=v6
	docker manifest push "$(IMAGE):$(VERSION)"
	docker manifest create "$(IMAGE):latest" \
		"$(IMG_NAME):linux-arm-latest"
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):linux-arm-latest" --os=linux --arch=arm --variant=v6
	docker manifest push "$(IMAGE):latest"

.PHONY: image push-image test
