#!make
include .env

export GITHUB_TOKEN := $(shell cat ~/.github_token 2>/dev/null || echo "")

EXTENSION := $(shell grep "name" extension/manifest.json | sed -n 's/.*"name":.*"\(.*\)",.*$$/\1/p')
VERSION := $(shell grep "version" extension/manifest.json | grep -Po '([0-9]+\.){2}[0-9]+')
ID := $(shell grep "id" extension/manifest.json | sed -n 's/.*"id":.*"\(.*\)",.*$$/\1/p')
LINK := https://github.com/p-wall/$(EXTENSION)/releases/download/$(VERSION)/$(EXTENSION).xpi

.PHONY: clean build release run bump

ifeq ($(shell (git status --porcelain | grep -q .) && echo dirty || echo clean),dirty)
	$(error git state not clean)
endif

clean:
	rm -rf web-ext-artifacts

build: clean
	web-ext sign --source-dir=extension --channel="unlisted" --api-key="$(WEB_EXT_API_KEY)" --api-secret="$(WEB_EXT_API_SECRET)"

release:
	cp web-ext-artifacts/*.xpi $(EXTENSION).xpi
	hub release create -a $(EXTENSION).xpi $(VERSION) -m "$(VERSION)"

run:
	web-ext run --source-dir=extension

bump:
	@current=$$(jq -r '.version' extension/manifest.json); \
	major=$$(echo $$current | cut -d. -f1); \
	minor=$$(echo $$current | cut -d. -f2); \
	patch=$$(echo $$current | cut -d. -f3); \
	new_patch=$$(($$patch + 1)); \
	new_version="$$major.$$minor.$$new_patch"; \
	jq ".version=\"$$new_version\"" extension/manifest.json | sponge extension/manifest.json; \
	jq ".version=\"$$new_version\"" package.json | sponge package.json; \
	jq ".addons[].updates[].version=\"$$new_version\"" updates.json | sponge updates.json; \
	jq ".addons[].updates[].update_link=\"https://github.com/p-wall/dex-submit/releases/download/$$new_version/dex-submit.xpi\"" updates.json | sponge updates.json; \
	echo "Version bumped: $$current -> $$new_version"
