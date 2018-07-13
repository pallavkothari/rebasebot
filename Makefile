TAG	:= $$(git log -1 --pretty=%h)
IMG := rebasebot:${TAG}
IMG_LATEST := rebasebot:latest
REGISTRY_NAME := ${REGISTRY}/${DOCKER_USER}/${IMG}

build:
	@go build
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${REGISTRY_NAME}
	@docker tag ${IMG} ${IMG_LATEST}

login:
	@docker login ${REGISTRY}

push:
	@docker push ${REGISTRY_NAME}

run:
	@env | grep -e 'GITHUB_' -e 'PORT' -e 'SECRET' -e 'HTTP' > .env
	@cat .env
	@docker run --env-file .env --rm -p ${PORT}:${PORT} ${IMG}

inspect-tags:
	@docker inspect --format='{{index .RepoTags}}' ${IMG}


heroku-push:
	@heroku container:login
	@heroku container:push web
	@heroku container:release web

echo:
	@echo ${REGISTRY}
	@echo ${REGISTRY_NAME}