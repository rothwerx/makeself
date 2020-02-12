.PHONY: all clean test help container-image

define NL


endef

VERSION := $(shell cat VERSION)
OUTPUT  := makeself-$(VERSION).run
VCS_REF := $(strip $(shell git rev-parse --short HEAD))
BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

all: $(OUTPUT)

$(OUTPUT): makeself.sh makeself-header.sh VERSION
	./make-release.sh

clean:
	$(RM) makeself-*.run

test:
	$(foreach f, \
		$(notdir $(sort $(filter-out test/bashunit,$(wildcard test/*)))), \
		cd test; \
		if ! ./$(f); then \
			echo; \
			echo "*** ERROR: Test '$(f)' failed!"; \
			echo; \
			exit 1; \
		fi$(NL))

help:
	$(info Targets: all $(OUTPUT) clean test help container-image)

container-image:
	docker image build \
		--build-arg VCS_REF=$(VCS_REF) \
		--build-arg VERSION=$(VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		-t rothwerx/makeself:$(VERSION) .
