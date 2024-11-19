.PHONY: cluster down setup_test_env dev test

# shell
SHELL := /bin/bash

# constants
PROJECT := $(shell basename $(CURDIR))

# Cluster ops
cluster:
	@ kind get clusters | grep $(PROJECT) \
 		&& echo "Cluster already exists" \
 		|| kind create cluster --name $(PROJECT) --config .kind.yaml
	@ echo " >> Cluster created << "
	@ echo " >> Setting up Cluster Dependencies... << "
	@ $(MAKE) -f $(CURDIR)/Makefile dependencies --no-print-directory

down:
	@ kind delete cluster --name $(PROJECT)

# Environments
setup_test_env: cluster
	@ skaffold build --file-output build.json
	@ skaffold deploy -a build.json --load-images=true

dev: cluster
	@ skaffold dev -w skaffold.yaml

test: setup_test_env
	@ skaffold verify -a build.json || ($(MAKE) down && exit 1)
	@ $(MAKE) down
