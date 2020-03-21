BASE_PATH = app
PROJECT_NAME = uploads3
IMAGE = $(PROJECT_NAME):latest
ENV = dev

# Container
copy_requirements:
	@cp $(BASE_PATH)/$(PROJECT_NAME)/requirements.txt docker/resources/requirements.txt

image: copy_requirements
	@docker build -f docker/Dockerfile -t $(IMAGE) ./docker
	@rm docker/resources/requirements.txt

container:
	@docker run --rm -it\
	 -v $(PWD)/$(BASE_PATH):/$(BASE_PATH) \
	 -v ~/.aws/config:/root/.aws/config \
	 -v ~/.aws/credentials:/root/.aws/credentials \
	 -w /$(BASE_PATH)/$(PROJECT_NAME) \
	 -p 8080:8080/ \
	 $(IMAGE) \
	 $(COMMAND)

ssh:
	@make container COMMAND=sh

# Chalice
deploy:
	@make container COMMAND="chalice deploy --stage=$(ENV)"

delete:
	@make container COMMAND="chalice delete --stage=$(ENV)"

up:
	@make container COMMAND="chalice local --host=0.0.0.0 --port=8080"
