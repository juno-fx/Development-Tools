.PHONY: cluster down

# shell
SHELL := /bin/bash

# constants
RANDOM_FILE := .random_id
RANDOM_ID := $(shell if [ -f $(RANDOM_FILE) ]; then cat $(RANDOM_FILE); else str=$$(tr -dc 'a-z' </dev/urandom | head -c6); echo $$str > $(RANDOM_FILE); echo $$str; fi)
PROJECT := $(shell basename $(CURDIR) | tr '[:upper:]' '[:lower:]')-$(RANDOM_ID)

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
