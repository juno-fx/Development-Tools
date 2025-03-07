.PHONY: env install lint format check

# shell
SHELL := /bin/bash

# Development targets
env:
	@ echo " >> Setting Up Node << "
	@ which pnpm > /dev/null || devbox add pnpm

install:
	@ echo " >> Running Node Install... << "
	@ pnpm install --dev

lint:
	@ pnpm run prettier -c src

format:
	@ pnpm run prettier --write src

check:
	@ pnpm run prettier src
