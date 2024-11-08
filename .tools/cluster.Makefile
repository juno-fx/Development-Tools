# constants
PROJECT := $(shell basename $(CURDIR))

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

# Environments
setup_test_env: cluster
	# Build the required artifacts and export them to the
	# build file for use in the next steps
	@ skaffold build --file-output build.json -p test

	# Force load images into the cluster
	@ skaffold deploy -a build.json --load-images=true -p test

dev: cluster
	@ skaffold dev -w skaffold.yaml
