# runtimes
PYTHON := true
NODE := true
ENV := PYTHON=$(PYTHON) NODE=$(NODE)


# updater
update-tools:
	@ $(MAKE) -f .tools/update.Makefile update-tools --no-print-directory

# Development targets
install:
	@ $(MAKE) -f .tools/dev.Makefile install $(ENV) --no-print-directory

lint:
	@ $(MAKE) -f .tools/dev.Makefile lint $(ENV) --no-print-directory

format:
	@ $(MAKE) -f .tools/dev.Makefile format $(ENV) --no-print-directory

check-format:
	@ $(MAKE) -f .tools/dev.Makefile check-format $(ENV) --no-print-directory

# Environment targets
dev:
	@ $(MAKE) -f .tools/cluster.Makefile dev --no-print-directory

down:
	@ $(MAKE) -f .tools/cluster.Makefile down --no-print-directory

dependencies:
	@ echo " >> Add cluster dependencies here << "
