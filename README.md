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

<br/>

## Criteria

- [x] **Consistency**: Provide a consistent development experience across all repositories.
- [x] **Ease of Use**: Easy to use and should not require a lot of setup.
- [x] **Onboarding**: Decrease the time it takes to onboard new developers.
- [x] **CI/CD**: Must be used in a CI/CD pipeline, enabling all steps to be run locally by the developer.

<br/>

## Required Tools

- [Devbox](https://www.jetify.com/docs/devbox/installing_devbox/)
- [Docker](https://docs.docker.com/engine/install/)
- [Make](https://www.gnu.org/software/make/)

<br/>

## Repository Setup

<br/>

#### Update gitignore

Add the following lines to your `.gitignore` file to prevent the development tools from being
committed to the repository.

```gitignore
.devbox/
.tools/
```

<br/>

#### Initial Setup

We provide an easy way to initially provision a new repository with the development tools using
an installation script.

```shell
curl https://raw.githubusercontent.com/juno-innovations/development-tools/main/install.sh | bash
```

<br/>

#### Update Existing Setup

If you have a repository that is already using the development tools, and you want to update to 
the latest version, we pull the tools using Devbox's init_hook. But if you want to do it manually,
you can run the following command.

```shell
make update-tools
```

This will download and setup the latest version of the development tools.

<br/>

## Configuration

The primary point of configuration is in the root `Makefile` of the repository.

<br/>

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

<br/>

#### Kubernetes Workflow

Most repositories Juno Innovations handles are Kubernetes based. We provide a set of tools that can
be used to streamline the development process.

<br/>

##### Dependency Injection

To configure cluster dependencies, such as Custom Resource Definitions (CRDs), you can add them to 
the `Makefile` hook called `dependencies`.

```makefile
dependencies:
	@ echo " >> Add cluster dependencies here << "
	@ kubectl apply -f ./path/to/dependency.yaml
```

<br/>

##### KinD

We use KinD to run a local Kubernetes cluster for development. To configure KinD, you can add the
necessary configuration file called `.kind.yaml` at the root of the repository. We provide a default
configuration in this repository that can be used as a starting point.

<br/>

##### skaffold

We will use `skaffold` to build and deploy the application to the Kubernetes cluster. There is no
need to install `skaffold` as it is already included in the development tools via Devbox.

To configure `skaffold`, you can add the necessary configuration to the `skaffold.yaml` file at the
root of the repository. We provide a default configuration in this repository that can be used as 
a starting point.

<br/>

##### The `k8s` Folder

This is where all the Kubernetes manifests should be stored. This is where you can configure the 
deployment, service, ingress, etc. for your development/testing environment.

<br/>

## Workflow

We minimized and distilled the development process into a few simple commands that can be run in the
root of the repository.

Steps:
- Enter the Devbox environment by running the following command:
    ```shell
    devbox shell
    ```
- If developing a Microservice, start development environment:
    ```shell
    make dev
    ```
- Run test suite:
    ```shell
    make test
    ```
- Run Formatter:
    ```shell
    make format
    ```
- Run Linter:
    ```shell
    make lint
    ```
- Clean up for the day:
    ```shell
    make down
    ```
- Exit the Devbox environment:
    ```shell
    exit
    ```

<br/>

## CI/CD

The Juno Innovations CI/CD pipeline is configured to use the development tools. This means that all
the steps that are run in the pipeline can be run locally by the developer. This provides a consistent
development experience across all repositories.

An example of this in practice is how the CI runs tests. The CI runs the following command:

```yaml
name: Testing
on:
  workflow_dispatch:
  workflow_call:

jobs:
  test:
    name: Testing
    steps:
      - name: Clone Source Code
        uses: actions/checkout@v4
        with:
          submodules: 'true'

      - name: Run Tests
        run: devbox run -- make test
```

This will initialize the devbox environment and then run your test suite in the CI just like it would
locally.

<br/>

#### Linting and Formatting

Linting and formatting are also run in the CI pipeline. But it uses the `make check` command which
will run both the linter and the formatter in check mode. This allows the developer to preemptively
fix any issues before they are caught in the CI pipeline and save on CI cycles.

> We highly recommend running `make check` before pushing your changes.
