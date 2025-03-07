.PHONY: env install lint format check

# shell
SHELL := /bin/bash

# Development targets
env:
	@ echo " >> Setting Up Node << "
	@ which pnpm > /dev/null || devbox add pnpm

install:
	@ echo " >> Running Node Install... << "
	@ pnpm install

lint:
	@ yarn run prettier -c src
	@ yarn next lint

format:
	@ yarn run prettier --write src
	@ yarn next lint --fix

check: lint format
