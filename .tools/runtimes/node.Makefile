.PHONY: env install lint format check

# shell
SHELL := /bin/bash

# Development targets
env:
	@ echo " >> Setting Up Node << "
	@ which pnpm || (devbox add pnpm && refresh)

install:
	@ echo " >> Running Node Install... << "
	@ yarn install --dev

lint:
	@ yarn run prettier -c src

format:
	@ yarn run prettier --write src

check:
	@ yarn run prettier src
