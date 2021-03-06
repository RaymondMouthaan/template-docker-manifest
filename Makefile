IMAGE := raymondmm/docker-manifest
VERSION := v1.2.6

test:
	true

build-image:
	docker build --file Dockerfile.linux-amd64 --tag $(IMAGE):linux-amd64-latest .
	docker build --file Dockerfile.linux-arm32v6 --tag $(IMAGE):linux-arm32v6-latest .
	docker build --file Dockerfile.linux-arm32v7 --tag $(IMAGE):linux-arm32v7-latest .
	docker build --file Dockerfile.linux-arm64v8 --tag $(IMAGE):linux-arm64v8-latest .
	
tag-image:
	docker tag $(IMAGE):linux-amd64-latest $(IMAGE):linux-amd64-$(VERSION)
	docker tag $(IMAGE):linux-arm32v6-latest $(IMAGE):linux-arm32v6-$(VERSION)
	docker tag $(IMAGE):linux-arm32v7-latest $(IMAGE):linux-arm32v7-$(VERSION)
	docker tag $(IMAGE):linux-arm64v8-latest $(IMAGE):linux-arm64v8-$(VERSION)
	
push-image:
	docker push $(IMAGE):linux-amd64-latest
	docker push $(IMAGE):linux-amd64-$(VERSION)
	docker push $(IMAGE):linux-arm32v6-latest
	docker push $(IMAGE):linux-arm32v6-$(VERSION)
	docker push $(IMAGE):linux-arm32v7-latest
	docker push $(IMAGE):linux-arm32v7-$(VERSION)
	docker push $(IMAGE):linux-arm64v8-latest
	docker push $(IMAGE):linux-arm64v8-$(VERSION)
	
manifest-list-image:
	docker manifest create "$(IMAGE):$(VERSION)" \
		"$(IMAGE):linux-amd64-$(VERSION)" \
		"$(IMAGE):linux-arm32v6-$(VERSION)" \
		"$(IMAGE):linux-arm32v7-$(VERSION)" \
		"$(IMAGE):linux-arm64v8-$(VERSION)"
	docker manifest annotate "$(IMAGE):$(VERSION)" "$(IMAGE):linux-arm32v6-$(VERSION)" --os=linux --arch=arm --variant=v6
	docker manifest annotate "$(IMAGE):$(VERSION)" "$(IMAGE):linux-arm32v7-$(VERSION)" --os=linux --arch=arm --variant=v7
	docker manifest annotate "$(IMAGE):$(VERSION)" "$(IMAGE):linux-arm64v8-$(VERSION)" --os=linux --arch=arm64 --variant=v8
	docker manifest push "$(IMAGE):$(VERSION)"
	
	docker manifest create "$(IMAGE):latest" \
		"$(IMAGE):linux-amd64-latest" \
		"$(IMAGE):linux-arm32v6-latest" \
		"$(IMAGE):linux-arm32v7-latest" \
		"$(IMAGE):linux-arm64v8-latest"
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):linux-arm32v6-latest" --os=linux --arch=arm --variant=v6
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):linux-arm32v7-latest" --os=linux --arch=arm --variant=v7
	docker manifest annotate "$(IMAGE):latest" "$(IMAGE):linux-arm64v8-latest" --os=linux --arch=arm64 --variant=v8
	docker manifest push "$(IMAGE):latest"

.PHONY: image push-image test
