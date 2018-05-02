IMAGE := docker-manifest-arm-linux:v1

test:
	true

image:
	docker build -t $(IMAGE) .

push-image:
	docker push $(IMAGE)

.PHONY: image push-image test
