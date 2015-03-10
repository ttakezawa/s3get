NAME = s3get
VERSION = $(shell awk -F\" '/^const Version/ { print $$2 }' $(NAME).go)
OSARCH = "linux/amd64 darwin/amd64"

GITHUB_REPO = ttakezawa/$(NAME)
IMAGE = ttakezawa/$(NAME)

all: build

build:
	@mkdir -p bin
	go build -o bin/$(NAME)

deps:
	go get -u github.com/progrium/gh-release/...
	go get -u github.com/mitchellh/gox/...
	gox -build-toolchain -osarch=$(OSARCH)

xcompile:
	@mkdir -p build
	gox -osarch=$(OSARCH) -output="build/{{.OS}}_{{.Arch}}/$(NAME)"

release:
	@mkdir -p release
	$(eval FILES := $(shell ls build))
	for f in $(FILES); do \
		tar -zcf release/$(NAME)_$(VERSION)_$$f.tgz -C build/$$f $(NAME); \
	done
	gh-release checksums sha256
	gh-release create $(GITHUB_REPO) $(VERSION) $(shell git rev-parse --abbrev-ref HEAD) v$(VERSION)

docker-build:
	docker build -t $(IMAGE):$(VERSION) .

test-docker-image:
	@test "$(NAME): v$(VERSION)" = "$$(docker run --rm $(IMAGE):$(VERSION) --version)"
	@echo "OK. $(NAME): v$(VERSION)"

docker-push:
	docker push $(IMAGE):$(VERSION)

clean:
	rm -rf bin build release

.PHONY: all build deps xcompile release docker-build docker-push
