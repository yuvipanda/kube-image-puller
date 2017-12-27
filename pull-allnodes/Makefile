VERSION=$(shell git rev-parse --short HEAD)
IMAGE=ryanlovett/image-allnodes-puller

release: VERSION=$(shell git tag -l --points-at HEAD)

build:
	docker build -t $(IMAGE):$(VERSION) .

push:
	docker push $(IMAGE):$(VERSION)

release: build push
