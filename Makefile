IMG := rebasebot:latest
REGISTRY := ops0-artifactrepo1-0-prd.data.sfdc.net
SFCI_NAME := ${REGISTRY}/zero/${IMG}

build:
	@go build
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${SFCI_NAME}

login:
	@docker login ${REGISTRY}

push:
	@docker push ${SFCI_NAME}

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

