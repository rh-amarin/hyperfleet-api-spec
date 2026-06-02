# HyperFleet OpenAPI spec

This repository supports the development of the Hyperfleet OpenAPI contract, but is not the source-of-truth for the OpenAPI contract.

This project hosts the TypeSpec files to generate the HyperFleet core OpenAPI specification. TypeSpec is an implementation detail providing better ergonomics than writing contracts in plain YAML. The repository generates the core provider contract; the provider-specific contract lives in [hyperfleet-api-spec-template](https://github.com/openshift-hyperfleet/hyperfleet-api-spec-template).

Browse the generated core contract in Swagger UI (GitHub Pages):

- <https://openshift-hyperfleet.github.io/hyperfleet-api-spec/index.html>

## Consuming the API Specifications

### Source of truth (Production contract)

The OpenAPI contract that gets promoted to production is the one at:

- <https://raw.githubusercontent.com/openshift-hyperfleet/hyperfleet-api/refs/heads/main/openapi/openapi.yaml>

**Download examples**:

```bash
curl -L -O https://github.com/openshift-hyperfleet/hyperfleet-api/releases/latest/download/openapi.yaml

```

### Latest Releases (Recommended for development)

Download the latest stable OpenAPI specifications directly from GitHub Releases:

**Direct URL** (always gets the latest stable version):

- Core: `https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/core-openapi.yaml`

**Download example**:

```bash
curl -L -O https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/core-openapi.yaml
```

**Use in code generation** (always uses latest stable version):

```bash
openapi-generator generate -i https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/latest/download/core-openapi.yaml -g go -o ./client
```

### Version-Specific Downloads

To download a specific version (e.g., v1.0.0):

```bash
curl -L -O https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/download/v1.0.0/core-openapi.yaml
```

**See all releases**: <https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases>

## Repository Structure

The repository is organized with root-level configuration files and two main directories:

### Root-Level Files

- **`index.html`** - Swagger UI for browsing the core contract on GitHub Pages (swagger-ui-dist 5.32.6)
- **`main.tsp`** - Main TypeSpec entry point that imports all service definitions
- **`tspconfig.yaml`** - TypeSpec compiler configuration

### `/shared`

Contains models and services shared across providers (also published as an npm package for consumption by provider-specific repos like `hyperfleet-api-spec-template`):

- **`shared/models/clusters/`** - Cluster resource definitions (interfaces and base models)
- **`shared/models/statuses/`** - Status resource definitions for clusters and nodepools
- **`shared/models/nodepools/`** - NodePool resource definitions
- **`shared/models/resource/`** - Generic Resource type for non-cluster entity types
- **`shared/models/common/`** - Common models and types (APIMetadata, Error, QueryParams, etc.)
- **`shared/services/`** - Shared service endpoints (clusters, nodepools, statuses, resources)

### `/core`

Contains core-specific models and internal services:

- **`core/models/cluster/`** - Core cluster spec (`CoreClusterSpec` as `Record<unknown>`)
- **`core/services/statuses-internal.tsp`** - Status write endpoints (PUT - internal adapters only)
- **`core/services/force-delete-internal.tsp`** - Force-delete endpoints (internal only)

#### Public vs Internal API Split

The status endpoints are split into two files to support different API consumers:

| File                                  | Operations  | Audience          | Included in Build |
| ------------------------------------- | ----------- | ----------------- | ----------------- |
| `shared/services/statuses.tsp`        | GET (read)  | External clients  | ✅ Yes (default)  |
| `core/services/statuses-internal.tsp` | PUT (write) | Internal adapters | ❌ No (opt-in)    |

**Why the split?**

- **External clients** (UI, CLI, monitoring) only need to read status information
- **Internal adapters** (validator, provisioner, dns) need to write/update status reports
- Separating these allows generating different API contracts for different audiences

## Prerequisites

After cloning the repository, install all dependencies:

```bash
npm install
```

This installs the TypeSpec compiler and all required libraries into `node_modules/`. The build scripts invoke `tsp` directly from `node_modules/.bin/`, so no global install is needed.

## Building OpenAPI Specifications

The repository uses a single `main.tsp` entry point.

### Using npm Scripts (Recommended)

```bash
npm run build
```

### Using the Build Script Directly

```bash
./build-schema.sh
```

The script:

1. Syncs `package.json` version from `main.tsp`
2. Compiles the TypeSpec from `main.tsp`
3. Outputs `schemas/core/openapi.yaml`

### Manual Build (Alternative)

```bash
node_modules/.bin/tsp compile main.tsp
```

Output: `tsp-output-core/schema/openapi.yaml`

## Architecture

The HyperFleet API provides simple CRUD operations for managing cluster resources and their status history:

- **Simple CRUD only**: No business logic, no event creation
- **Separation of concerns**: API layer focuses on data persistence; orchestration logic is handled by external components

## Adding a New Provider

Provider-specific contracts live in their own repository and consume this repo as an npm package (the `hyperfleet` package). See [hyperfleet-api-spec-template](https://github.com/openshift-hyperfleet/hyperfleet-api-spec-template) for a reference implementation.

## Adding a New Service

To add a new service (e.g., with additional endpoints):

1. Create a new service file: `services/new-service.tsp`

   ```typescript
   import "@typespec/http";
   import "@typespec/openapi";
   import "../models/common/model.tsp";
   // ... other imports as needed

   namespace HyperFleet;
   @route("/new-resource")
   interface NewService {
     // ... endpoint definitions
   }
   ```

2. Import the new service in `main.tsp`:

   ```typescript
   import "./services/new-service.tsp";
   ```

## Dependencies

- `@typespec/compiler` - TypeSpec compiler
- `@typespec/http` - HTTP protocol support
- `@typespec/openapi` - OpenAPI decorators
- `@typespec/openapi3` - OpenAPI 3.0 emitter

## Updating the Specification

### Making an API change

1. **Edit the TypeSpec sources** in `shared/` or `core/`.

2. **Bump the version** in `main.tsp`:

   ```typescript
   @info(#{ version: "1.0.19", ... })
   ```

3. **Rebuild the schema**:

   ```bash
   ./build-schema.sh
   ```

   This also updates `package.json` version automatically — no need to edit it manually.

4. **Update [CHANGELOG.md](CHANGELOG.md)** — move your changes from `[Unreleased]` into a new versioned entry.

5. **Open a PR.** CI enforces three things automatically:
   - Committed schema and `package.json` match freshly generated output (catches manual edits or forgotten rebuilds).
   - OpenAPI 3.0 schema passes `spectral:oas` linting.
   - Version in `main.tsp` is higher than the latest GitHub release tag.

6. **Merge to main.** The release workflow runs automatically: it creates an annotated tag (`vX.Y.Z`), builds the schema from scratch, and publishes a GitHub release with `core-openapi.yaml` attached.

### Consuming schemas as a Go module

Each release tag is a valid Go module version. Import the embedded schemas:

```go
import specschemas "github.com/openshift-hyperfleet/hyperfleet-api-spec/schemas"

data, err := specschemas.FS.ReadFile("core/openapi.yaml")
```

To update a consumer after a new release:

```bash
go get github.com/openshift-hyperfleet/hyperfleet-api-spec@v1.0.18
```

To test locally against an unreleased branch, use a `replace` directive in your `go.mod`:

```go
replace github.com/openshift-hyperfleet/hyperfleet-api-spec => /path/to/local/hyperfleet-api-spec
```

See [hyperfleet-api docs/openapi-spec.md](https://github.com/openshift-hyperfleet/hyperfleet-api/blob/main/docs/openapi-spec.md) for how the hyperfleet-api service consumes this module.

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:

- Development setup and workflow
- Repository structure details
- Testing guidelines
- Commit standards
- Pull request process

## Developing with the Visual Studio TypeSpec extension

This repository compiles a single `main.tsp` entry point for the core contract. The TypeSpec extension may show false errors for models in `shared/` that are only resolved at compile time, but both `build-schema.sh` and the "Emit from TypeSpec" command work correctly.
