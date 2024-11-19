.PHONY: update-tools install lint check format dev dependencies down test

# shell
SHELL := /bin/bash

# runtimes
PYTHON := true
NODE := true
ENV := PYTHON=$(PYTHON) NODE=$(NODE)


# updater
update-tools:
	@ echo " >> Pulling Latest Tools << "
	@ rm -rf Development-Tools
	@ git clone https://github.com/juno-fx/Development-Tools.git
	@ rm -rf .tools
	@ mv -v Development-Tools/.tools .tools
	@ rm -rf Development-Tools
	@ echo " >> Tools Updated << "

# Development targets
install: .tools/cluster.Makefile
	@ $(MAKE) -f .tools/dev.Makefile install $(ENV) --no-print-directory

lint: .tools/cluster.Makefile
	@ $(MAKE) -f .tools/dev.Makefile lint $(ENV) --no-print-directory

format: .tools/cluster.Makefile
	@ $(MAKE) -f .tools/dev.Makefile format $(ENV) --no-print-directory

check: .tools/cluster.Makefile
	@ $(MAKE) -f .tools/dev.Makefile check $(ENV) --no-print-directory

# Environment targets
dev: .tools/cluster.Makefile
	@ $(MAKE) -f .tools/cluster.Makefile dev --no-print-directory

down:
	@ $(MAKE) -f .tools/cluster.Makefile down --no-print-directory

dependencies:
	@ echo " >> Add cluster dependencies here << "

.tools/cluster.Makefile:
	@ $(MAKE) update-tools

test: .tools/cluster.Makefile
	@ $(MAKE) -f .tools/cluster.Makefile test $(ENV) --no-print-directory
