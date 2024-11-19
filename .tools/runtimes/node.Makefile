.PHONY: env install lint format check

# Development targets
env:
	@ echo " >> Setting up Node << "

install:
	@ echo " >> Running Node Install... << "
	@ yarn install --dev

lint:
	@ yarn run prettier -c src

format:
	@ yarn run prettier --write src

check:
	@ yarn run prettier src
