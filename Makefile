VERSION = 0.1.0
PREFIX = nginx-prometheus-exporter
TAG = $(VERSION)
GIT_COMMIT = $(shell git rev-parse --short HEAD)

test:
	go test ./...

container:
	docker build --build-arg VERSION=$(VERSION) --build-arg GIT_COMMIT=$(GIT_COMMIT) -t $(PREFIX):$(TAG) . 

push: container
	docker push $(PREFIX):$(TAG)

binaries:
	GOARCH=amd64 CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags "-X main.version=${VERSION} -X main.gitCommit=${GIT_COMMIT}" -o nginx-prometheus-exporter_amd64 .
	GOARCH=386 CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags "-X main.version=${VERSION} -X main.gitCommit=${GIT_COMMIT}" -o nginx-prometheus-exporter_i386 .
