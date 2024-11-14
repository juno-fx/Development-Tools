<br />
<p align="center">
    <img src="https://avatars.githubusercontent.com/u/77702266?s=200&v=4" style="border-radius: 50px"/>
    <h3 align="center">Development Tools</h3>
    <p align="center">
        Juno Innovations Development Toolset
    </p>
</p>

## Summary

[Juno Innovations](https://www.juno-innovations.com/) handles a number of different repositories with a number of different runtimes. 
The intention of this repository is to provide a set of tools that can be used to streamline the 
development process. This provides a consistent development experience across all repositories which
decreases the time it takes to onboard new developers and increases the overall productivity of
the development team.

## Criteria

- [x] **Consistency**: Provide a consistent development experience across all repositories.
- [x] **Ease of Use**: Easy to use and should not require a lot of setup.
- [x] **Onboarding**: Decrease the time it takes to onboard new developers.
- [x] **CI/CD**: Must be used in a CI/CD pipeline, enabling all steps to be run locally by the developer.

## Required Tools

- [Devbox](https://www.jetify.com/docs/devbox/installing_devbox/)
- [Docker](https://docs.docker.com/engine/install/)
- [Make](https://www.gnu.org/software/make/)

## Repository Setup

#### Initial Setup

We provide an easy way to initially provision a new repository with the development tools using
an installation script.

```shell
curl https://raw.githubusercontent.com/juno-innovations/development-tools/main/install.sh | bash
```

#### Update Existing Setup

If you have a repository that is already using the development tools, and you want to update to 
the latest version, we pull the tools using Devbox's init_hook. But if you want to do it manually,
you can run the following command.

```shell
make update-tools
```

This will download and setup the latest version of the development tools.

## Configuration

The primary point of configuration is in the root `Makefile` of the repository.

#### Runtimes

At the top of the file you should see a section that looks like this:

```makefile
# runtimes
PYTHON := true
NODE := true
ENV := PYTHON=$(PYTHON) NODE=$(NODE)
```

This is where you can enable or disable the runtimes that you need for your repository. By default,
both Python and Node are enabled. If you only need one of them, you can disable the other by setting
it to `false`.

#### Kubernetes Workflow

Most repositories Juno Innovations handles are Kubernetes based. We provide a set of tools that can
be used to streamline the development process.

##### Dependency Injection

To configure cluster dependencies, such as Custom Resource Definitions (CRDs), you can add them to 
the `Makefile` hook called `dependencies`.

```makefile
dependencies:
	@ echo " >> Add cluster dependencies here << "
	@ kubectl apply -f ./path/to/dependency.yaml
```

##### KinD

We use KinD to run a local Kubernetes cluster for development. To configure KinD, you can add the
necessary configuration file called `.kind.yaml` at the root of the repository. We provide a default
configuration in this repository that can be used as a starting point.

##### skaffold

We will use `skaffold` to build and deploy the application to the Kubernetes cluster. There is no
need to install `skaffold` as it is already included in the development tools via Devbox.

To configure `skaffold`, you can add the necessary configuration to the `skaffold.yaml` file at the
root of the repository. We provide a default configuration in this repository that can be used as 
a starting point.

##### The `k8s` Folder

This is where all the Kubernetes manifests should be stored. This is where you can configure the 
deployment, service, ingress, etc. for your development/testing environment.
