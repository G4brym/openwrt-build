#
# GNU Makefile
#


SHELL := bash -e

OPENWRT_RELEASE := 22.03.2

OPENWRT_TARGET := ath79
OPENWRT_SUBTARGET := generic
OPENWRT_PROFILE := tplink_archer-c6-v2

DOCKER_IMAGE := openwrt-custom-builder:$(OPENWRT_RELEASE)


.PHONY: all
all: build

.PHONY: build
build:
	sed 's/__CACHE_BUSTER__/$(shell date +%s)/g' Dockerfile \
	| docker build -t $(DOCKER_IMAGE) -f - \
	       --build-arg OPENWRT_TARGET=$(OPENWRT_TARGET) \
	       --build-arg OPENWRT_SUBTARGET=$(OPENWRT_SUBTARGET) \
	       --build-arg OPENWRT_PROFILE=$(OPENWRT_PROFILE) \
	       --build-arg OPENWRT_RELEASE=$(OPENWRT_RELEASE) \
	       .
	mkdir -p firmware
	docker run --rm --name openwrt-build $(DOCKER_IMAGE) tar -c -C "bin/targets/$(OPENWRT_TARGET)/$(OPENWRT_SUBTARGET)" . | tar x -C firmware

.PHONY: clean
clean:
	rm -rf firmware


# EOF - Makefile
