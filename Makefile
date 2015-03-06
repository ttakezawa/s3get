# Refer: https://github.com/gliderlabs/glidergun/blob/master/Makefile

NAME=s3get
BINARYNAME=s3get
ARCH=$(shell uname -m)
VERSION=1.0.1.dev

build:
	mkdir -p build/Linux  && GOOS=linux  go build -ldflags "-X main.Version $(VERSION)" -o build/Linux/$(BINARYNAME)
	mkdir -p build/Darwin && GOOS=darwin go build -ldflags "-X main.Version $(VERSION)" -o build/Darwin/$(BINARYNAME)

deps:
	go get -u github.com/progrium/gh-release/...
	go get || true

release:
	rm -rf release && mkdir release
	tar -zcf release/$(NAME)_$(VERSION)_Linux_$(ARCH).tgz -C build/Linux $(BINARYNAME)
	tar -zcf release/$(NAME)_$(VERSION)_Darwin_$(ARCH).tgz -C build/Darwin $(BINARYNAME)
	gh-release checksums sha256
	gh-release create ttakezawa/$(NAME) $(VERSION) $(shell git rev-parse --abbrev-ref HEAD) v$(VERSION)

clean:
	rm -rf build release

.PHONY: build release
