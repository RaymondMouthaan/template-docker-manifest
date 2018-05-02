IMAGE := raymondmm/docker-manifest
VERSION := v1.2.4

test:
	true

build-image:
	docker build --file Dockerfile.linux-arm32v6 --tag $(IMAGE):linux-arm32v6-latest .
	docker build --file Dockerfile.linux-arm32v7 --tag $(IMAGE):linux-arm32v7-latest .
tag-image:
	docker tag $(IMAGE):linux-arm32v6-latest $(IMAGE):linux-arm32v6-$(VERSION)
	docker tag $(IMAGE):linux-arm32v7-latest $(IMAGE):linux-arm32v7-$(VERSION)

push-image:
	docker push $(IMAGE):linux-arm32v6-latest
	docker push $(IMAGE):linux-arm32v6-$(VERSION)
	docker push $(IMAGE):linux-arm32v7-latest
	docker push $(IMAGE):linux-arm32v7-$(VERSION)

manifest-list-image:
	docker manifest create "$(IMAGE):$(VERSION)" \
		"$(IMAGE):linux-arm32v6-$(VERSION)" \
		"$(IMAGE):linux-arm32v7-$(VERSION)"
	docker manifest annotate "$(IMAGE):$(VERSION)" "$(IMAGE):linux-arm32v6-$(VERSION)" --os=linux --arch=arm --variant=v6
	docker manifest annotate "$(IMAGE):$(VERSION)" "$(IMAGE):linux-arm32v7-$(VERSION)" --os=linux --arch=arm --variant=v7
	docker manifest push "$(IMAGE):$(VERSION)"
	docker manifest create "$(IMAGE):latest" \
		"$(IMAGE):linux-arm32v6-latest" \
		"$(IMAGE):linux-arm32v7-latest"
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):linux-arm32v6-latest" --os=linux --arch=arm --variant=v6
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):linux-arm32v7-latest" --os=linux --arch=arm --variant=v7
	docker manifest push "$(IMAGE):latest"

.PHONY: image push-image test
