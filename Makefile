IMG_NAME :=	cblauvelt/modbus-server
# Get branch name
ifndef tag
	TAG := $(shell git rev-parse --abbrev-ref HEAD | sed -e 's/\//-/g')
else
	TAG := $(tag)
endif

$(info    Building with tag $(TAG))

build:
	docker build -t ${IMG_NAME}:${TAG} .

push:
	docker push ${IMG_NAME}:${TAG}
