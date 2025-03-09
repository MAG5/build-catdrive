KERNEL_BSP := https://github.com/hanwckf/linux-marvell/releases/download
RELEASE_TAG = v2019-9-16-1
DTB := armada-3720-catdrive.dtb

DTB_URL := $(KERNEL_BSP)/$(RELEASE_TAG)/$(DTB)
KERNEL_URL := $(KERNEL_BSP)/$(RELEASE_TAG)/Image
KMOD_URL := $(KERNEL_BSP)/$(RELEASE_TAG)/modules.tar.xz

TARGETS := alpine

DL := dl
DL_KERNEL := $(DL)/kernel/$(RELEASE_TAG)
OUTPUT := output

CURL := curl -O -L
download = ( mkdir -p $(1) && cd $(1) ; $(CURL) $(2) )

help:
	@echo "Usage: make build_[system1]=y build_[system2]=y build"
	@echo "available system: $(TARGETS)"

build: $(TARGETS)

clean: $(TARGETS:%=%_clean)
	rm -f $(RESCUE_ROOTFS)

dl_kernel: $(DL_KERNEL)/$(DTB) $(DL_KERNEL)/Image $(DL_KERNEL)/modules.tar.xz

$(DL_KERNEL)/$(DTB):
	$(call download,$(DL_KERNEL),$(DTB_URL))

$(DL_KERNEL)/Image:
	$(call download,$(DL_KERNEL),$(KERNEL_URL))

$(DL_KERNEL)/modules.tar.xz:
	$(call download,$(DL_KERNEL),$(KMOD_URL))

ALPINE_BRANCH := v3.10
ALPINE_VERSION := 3.10.4
ALPINE_PKG := alpine-minirootfs-$(ALPINE_VERSION)-aarch64.tar.gz
RESCUE_ROOTFS := tools/rescue/rescue-alpine-catdrive-$(ALPINE_VERSION)-aarch64.tar.xz

ALPINE_URL_BASE := http://dl-cdn.alpinelinux.org/alpine/$(ALPINE_BRANCH)/releases/aarch64

alpine_dl: dl_kernel $(DL)/$(ALPINE_PKG)

$(DL)/$(ALPINE_PKG):
	$(call download,$(DL),$(ALPINE_URL_BASE)/$(ALPINE_PKG))

alpine_clean:

$(RESCUE_ROOTFS):
	# @[ ! -f $(RESCUE_ROOTFS) ] && make rescue

rescue: alpine_dl
	sudo BUILD_RESCUE=y ./build-alpine.sh release $(DL)/$(ALPINE_PKG) $(DL_KERNEL) -

ifeq ($(build_alpine),y)
alpine: alpine_dl $(RESCUE_ROOTFS)
	sudo ./build-alpine.sh generate $(DL)/$(ALPINE_PKG) $(DL_KERNEL) $(RESCUE_ROOTFS)

else
alpine:
endif
