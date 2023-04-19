all: images

IMAGE_BASE=quay.io/opsmxpublic/

images: set-git-info
	docker buildx build \
		-f Dockerfile-java17-ubi8-minimal \
	    --pull \
	    --platform linux/amd64,linux/arm64 \
			-t ${IMAGE_BASE}image-base-java17-ubi8-minimal:latest \
			-t ${IMAGE_BASE}image-base-java17-ubi8-minimal:${GIT_BRANCH} . \
			--push
	docker buildx build \
		-f Dockerfile-java17-ubi87 \
	    --pull \
	    --platform linux/amd64,linux/arm64 \
			-t ${IMAGE_BASE}image-base-java17-ubi87:latest \
			-t ${IMAGE_BASE}image-base-java17-ubi87:${GIT_BRANCH} . \
			--push

#
# set git info details
#
set-git-info:
	@$(eval GIT_BRANCH=$(shell git describe --tags))
	@$(eval GIT_HASH=$(shell git rev-parse ${GIT_BRANCH}))

clean:

image-names: set-git-info
	[ -n "${GITHUB_OUTPUT}" ] && echo imageNames=${IMAGE_BASE}image-base-java17-ubi8-minimal:latest, ${IMAGE_BASE}image-base-java17-ubi8-minimal:${GIT_BRANCH} >> ${GITHUB_OUTPUT}
	[ -n "${GITHUB_OUTPUT}" ] && echo imageNames=${IMAGE_BASE}image-base-java17-ubi87:latest, ${IMAGE_BASE}image-base-java17-ubi87:${GIT_BRANCH} >> ${GITHUB_OUTPUT}
