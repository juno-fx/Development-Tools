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
install:
	@ $(MAKE) -f .tools/dev.Makefile install $(ENV) --no-print-directory

lint:
	@ $(MAKE) -f .tools/dev.Makefile lint $(ENV) --no-print-directory

format:
	@ $(MAKE) -f .tools/dev.Makefile format $(ENV) --no-print-directory

check:
	@ $(MAKE) -f .tools/dev.Makefile check $(ENV) --no-print-directory

# Environment targets
dev:
	@ $(MAKE) -f .tools/cluster.Makefile dev --no-print-directory

down:
	@ $(MAKE) -f .tools/cluster.Makefile down --no-print-directory

dependencies:
	@ echo " >> Add cluster dependencies here << "
