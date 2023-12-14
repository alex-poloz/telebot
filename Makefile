APP := $(shell basename $(shell git remote get-url origin))
REGESTRY :=ghcr.io/alex-poloz/telebot
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64
PATHNAME=${REGESTRY}:${VERSION}-${TARGETOS}-$(TARGETARCH)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o telebot -ldflags "-X="github.com/alex-poloz/telebot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}  --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
