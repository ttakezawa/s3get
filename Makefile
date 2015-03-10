NAME = s3get
VERSION = $(shell awk -F\" '/^const Version/ { print $$2 }' $(NAME).go)
OSARCH = "linux/amd64 darwin/amd64"
GITHUB_REPO = ttakezawa/$(NAME)

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
	gox -osarch=$(OSARCH) -output="build/{{.Dir}}_$(VERSION)_{{.OS}}_{{.Arch}}/$(NAME)"

release:
	@mkdir -p release
	$(eval FILES := $(shell ls build))
	for f in $(FILES); do \
		tar -zcf release/$$f.tgz -C build/$$f $(NAME); \
	done
	gh-release checksums sha256
	gh-release create $(GITHUB_REPO) $(VERSION) $(shell git rev-parse --abbrev-ref HEAD) v$(VERSION)

docker-build:
	docker build -t ttakezawa/s3get:$(VERSION) .
	@test "$(NAME): v$(VERSION)" = "$$(docker run --rm ttakezawa/s3get:$(VERSION) --version)"

clean:
	rm -rf bin build release

.PHONY: all build deps xcompile release docker-build docker-push
