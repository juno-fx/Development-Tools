.PHONY: cluster down

# shell
SHELL := /bin/bash

# constants
RANDOM_FILE := .random_id
RANDOM_ID := $(shell if [ -f $(RANDOM_FILE) ]; then cat $(RANDOM_FILE); else str=$$(tr -dc 'a-z' </dev/urandom | head -c6); echo $$str > $(RANDOM_FILE); echo $$str; fi)
PROJECT := $(shell basename $(CURDIR) | tr '[:upper:]' '[:lower:]')-$(RANDOM_ID)

# this is needed to clean nix paths from env vars that break vcluster
CLEAN_ENV := for v in $$(env | grep -E "(/|:)" | cut -d= -f1); do val=$${!v}; new=$$(echo "$$val" | tr ":" "\n" | grep -Ev "(/nix/|\\.nix|nix-)" | paste -sd: -); export $$v="$$new"; done;

# wrap vcluster with cleaned env. NOTE: this need to be wrapped again in a bash -c '' when used in commands
VCLUSTER := $(CLEAN_ENV) ./.devbox/nix/profile/default/bin/vcluster


# Cluster ops
cluster:
	@ bash -c '$(VCLUSTER) create $(PROJECT) --namespace $(PROJECT) --upgrade'
	@ echo " >> Cluster created << "
	@ echo " >> Setting up Cluster Dependencies... << "
	@ $(MAKE) -f $(CURDIR)/Makefile dependencies --no-print-directory

down:
	@ bash -c '$(VCLUSTER) delete $(PROJECT) --namespace $(PROJECT)'
