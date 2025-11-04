# HyperFleet OpenAPI spec

This project hosts the TypeSpec files to generate the HyperFleet OpenAPI specifications. The repository is organized to support multiple service variants (core, GCP, etc.) while sharing common models and interfaces.

## Repository Structure

The repository is organized with root-level configuration files and three main directories:

### Root-Level Files
- **`main.tsp`** - Main TypeSpec entry point that imports all service definitions
- **`aliases.tsp`** - Provider alias configuration file (re-linked to switch between providers)
- **`aliases-core.tsp`** - Core provider aliases (defines `ClusterSpec` as `CoreClusterSpec` which is `Record<unknown>`)
- **`aliases-gcp.tsp`** - GCP provider aliases (defines `ClusterSpec` as `GCPClusterSpec`)
- **`tspconfig.yaml`** - TypeSpec compiler configuration

### `/models`
Contains shared models used by all service variants:

- **`models/clusters/`** - Cluster resource definitions (interfaces and base models)
- **`models/statuses/`** - Status resource definitions for clusters and nodepools
- **`models/nodepools/`** - NodePool resource definitions
- **`models/compatibility/`** - Compatibility endpoints
- **`models/common/`** - Common models and types (APIResource, Error, QueryParams, etc.)

### `/models-core`
Contains core provider-specific model definitions:

- **`models-core/cluster/model.tsp`** - Defines `CoreClusterSpec` as `Record<unknown>` (generic)

### `/models-gcp`
Contains GCP provider-specific model definitions:

- **`models-gcp/cluster/model.tsp`** - Defines `GCPClusterSpec` with GCP-specific properties

### `/services`
Contains service definitions that generate the OpenAPI specifications:

- **`services/clusters.tsp`** - Cluster resource endpoints
- **`services/statuses.tsp`** - Status resource endpoints
- **`services/nodepools.tsp`** - NodePool resource endpoints
- **`services/compatibility.tsp`** - Compatibility endpoints

## Building OpenAPI Specifications

The repository uses a single `main.tsp` entry point. To generate either the core API or GCP API, you need to re-link the `aliases.tsp` file to point to the desired provider aliases file.

### Using the Build Script (Recommended)

The easiest way to build the OpenAPI schema is using the provided `build-schema.sh` script:

```bash
# Build Core API
./build-schema.sh core

# Build GCP API
./build-schema.sh gcp
```

The script automatically:
1. Validates the provider parameter
2. Re-links `aliases.tsp` to the appropriate provider aliases file
3. Compiles the TypeSpec to generate the OpenAPI schema
4. Outputs the result to `schemas/{provider}/openapi.yaml` (e.g., `schemas/core/openapi.yaml` or `schemas/gcp/openapi.yaml`)

**Extending to new providers**: Simply create `aliases-{provider}.tsp` and the script will automatically detect and support it.

### Manual Build (Alternative)

If you prefer to build manually:

#### Build Core API
1. Re-link `aliases.tsp` to `aliases-core.tsp`:
   ```bash
   ln -sf aliases-core.tsp aliases.tsp
   ```
   
2. Compile the TypeSpec:
   ```bash
   tsp compile main.tsp
   ```
   
   Output: `tsp-output/schema/openapi.yaml`

#### Build GCP API
1. Re-link `aliases.tsp` to `aliases-gcp.tsp`:
   ```bash
   ln -sf aliases-gcp.tsp aliases.tsp
   ```
   
2. Compile the TypeSpec:
   ```bash
   tsp compile main.tsp
   ```
   
   Output: `tsp-output/schema/openapi.yaml`

**Note**: The `aliases.tsp` file controls which provider-specific `ClusterSpec` definition is used throughout the service definitions. By re-linking it to either `aliases-core.tsp` or `aliases-gcp.tsp`, you switch between the generic `Record<unknown>` spec and the GCP-specific `GCPClusterSpec`.

## Architecture

The HyperFleet API provides simple CRUD operations for managing cluster resources and their status history:

- **Simple CRUD only**: No business logic, no event creation
- **Sentinel operator**: Handles all orchestration logic
- **Adapters**: Handle the specifics of managing provider-specific specs

## Adding a New Provider

To add a new provider (e.g., AWS):

1. Create provider model directory: `models-aws/cluster/model.tsp`
   ```typescript
   model AWSClusterSpec {
     awsProperty1: string;
     awsProperty2: string;
   }
   ```

2. Create provider aliases file: `aliases-aws.tsp`
   ```typescript
   import "./models-aws/cluster/model.tsp";
   alias ClusterSpec = AWSClusterSpec;
   ```

3. To generate the AWS API, re-link `aliases.tsp`:
   ```bash
   ln -sf aliases-aws.tsp aliases.tsp
   tsp compile main.tsp
   ```

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
