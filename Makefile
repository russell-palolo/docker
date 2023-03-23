ARTIFACTS_REPO ?= 686817240054.dkr.ecr.us-west-2.amazonaws.com
LOCAL_OS = $(shell uname | tr '[:upper:]' '[:lower:]')
LOCAL_ARCH = $(shell uname -m)
SKOPEO_VERSION ?= quay.io/skopeo/stable:v1.9.2

# download regctl binary
deps:
	curl -L https://github.com/regclient/regclient/releases/latest/download/regctl-$(LOCAL_OS)-$(LOCAL_ARCH) >./bin/regctl
	chmod 755 ./bin/regctl
_PHONY: deps

# authenticate docker 
login:
	aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $(ARTIFACTS_REPO)
_PHONY: login

# copy an image from upstream repo
sync: login
	../bin/regctl image copy $(IMAGE_REPOSITORY):$(IMAGE_VERSION) $(ARTIFACTS_REPO)/$(IMAGE_NAME):$(IMAGE_VERSION)
_PHONY: sync

# copy all images from upstream repo
syncall:
	@for f in $(shell ls -d */); do echo "Syncing image for $$f ..."; make -C $$f sync; done
_PHONY: syncall

# list available tags for the image
tags:
	docker run --rm $(SKOPEO_VERSION) list-tags docker://$(IMAGE_REPOSITORY) | jq -r '.Tags[]'
_PHONY: tags
