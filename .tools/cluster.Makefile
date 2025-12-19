.PHONY: cluster down setup_test_env dev test kind-config

# shell
SHELL := /bin/bash

# constants
PROJECT := $(shell basename $(CURDIR))
PROJECT_LOWER := $(shell echo "$(PROJECT)" | tr '[:upper:]' '[:lower:]')
MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))


kind-config:
	@ bash .tools/patch-kind-config.sh .kind.yaml

# Cluster ops
cluster: kind-config
	@ kind get clusters | grep $(PROJECT_LOWER) \
 		&& echo "Cluster already exists" \
 		|| kind create cluster --name $(PROJECT_LOWER) --config .kind.yaml.patched
	@ echo " >> Cluster created << "
	@ echo " >> Setting up Cluster Dependencies... << "
	@ $(MAKE) -f $(CURDIR)/Makefile dependencies --no-print-directory

down:
	@ kind delete cluster --name $(PROJECT_LOWER)

# Environments
setup_test_env: cluster
	@ skaffold build --file-output build.json
	@ skaffold deploy -a build.json --load-images=true

dev: cluster
	@ skaffold dev -w skaffold.yaml

test: setup_test_env
	@ skaffold verify -a build.json || ($(MAKE) down && exit 1)
	@ $(MAKE) down
