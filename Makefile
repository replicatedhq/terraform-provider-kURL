deps-aws:
	brew install tfenv
	brew install awscli
	tfenv init

setup-aws:
	./setup-aws.sh

init:
	tfenv init
	terraform init

plan:
	terraform plan

apply:
	terraform apply --auto-approve