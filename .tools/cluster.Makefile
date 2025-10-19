.PHONY: cluster down setup_test_env dev test

# shell
SHELL := /bin/bash

# constants
IN_CLUSTER := $(wildcard /var/run/secrets/kubernetes.io)

# Cluster ops
cluster:
ifeq ($(IN_CLUSTER),)
	@ echo "Using KinD..."
	@ $(MAKE) -f $(CURDIR)/.tools/cluster/kind.Makefile cluster --no-print-directory
else
	@ echo "Using vCluster..."
	@ $(MAKE) -f $(CURDIR)/.tools/cluster/vcluster.Makefile cluster --no-print-directory
endif

down:
ifeq ($(IN_CLUSTER),)
	@ echo "Using KinD..."
	$(MAKE) -f $(CURDIR)/.tools/cluster/kind.Makefile down --no-print-directory
else
	@ echo "Using vCluster..."
	$(MAKE) -f $(CURDIR)/.tools/cluster/vcluster.Makefile down --no-print-directory
endif

# Environments
setup_test_env: cluster
	@ skaffold build --file-output build.json
	@ skaffold deploy -a build.json --load-images=true

dev: cluster
	@ skaffold dev -w skaffold.yaml

test: setup_test_env
	@ skaffold verify -a build.json || ($(MAKE) down && exit 1)
	@ $(MAKE) down
