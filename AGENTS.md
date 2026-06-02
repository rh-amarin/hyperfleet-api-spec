# HyperFleet API Spec

TypeSpec sources that generate the HyperFleet core OpenAPI specification. Published as the `hyperfleet` npm package for provider-specific repos (e.g., `hyperfleet-api-spec-gcp`). Also consumed as a Go module via `schemas/schemas.go` (`embed.FS`).

## Critical path

```bash
npm install                                                    # Install TypeSpec compiler + deps
./build-schema.sh                                              # Build core OpenAPI spec
npx spectral lint schemas/core/openapi.yaml --fail-severity warn  # Lint (matches CI strictness)
```

**IMPORTANT:** `schemas/core/openapi.yaml` is committed. CI runs `git diff --exit-code schemas/` — if you change TypeSpec sources, rebuild and commit the schema in the same PR.

**IMPORTANT:** Every PR must bump the version in `main.tsp` (the `version` field inside the `@info` decorator). CI compares against the latest release tag and blocks if unchanged or lower.

When bumping version:
1. Edit the `version` field inside the `@info` decorator in `main.tsp`
2. Run `./build-schema.sh` (auto-syncs `package.json` version — never edit `package.json` manually)
3. Update `CHANGELOG.md`: add new `## [X.Y.Z] - YYYY-MM-DD` section, update comparison links

## Source of truth

| Topic | File |
|-------|------|
| Build process | `build-schema.sh` |
| CI checks | `.github/workflows/ci.yml` |
| Release automation | `.github/workflows/release.yml`, `RELEASING.md` |
| Contributing guide | `CONTRIBUTING.md` |
| Changelog format | `CHANGELOG.md` (Keep a Changelog) |
| Spectral rules | `.spectral.yaml` |
| TypeSpec config | `tspconfig.yaml` |
| Go module embed | `schemas/schemas.go` |

## Architecture: shared vs core

```
shared/          → Cross-provider models and services (npm package)
core/            → Core-only models and internal-only services
main.tsp         → Entry point (imports shared + core)
schemas/core/    → Generated output (committed)
```

**Where to put new code:**

| What | Where | Why |
|------|-------|-----|
| Models used by all providers | `shared/models/{resource}/model.tsp` | Published as npm package |
| Endpoints for external clients | `shared/services/{resource}.tsp` | Shared across provider contracts |
| Internal-only endpoints (adapters) | `core/services/{resource}-internal.tsp` | Core contract only |
| Core-specific model overrides | `core/models/{resource}/model.tsp` | Not shared |
| Provider-specific models | Separate repo (e.g., `hyperfleet-api-spec-gcp`) | Own contract |

**Directory naming:** `shared/models/` uses plural names (`clusters/`, `nodepools/`, `statuses/`) except `resource/` and `common/`. `core/models/` uses singular names (`cluster/`, `nodepool/`). Follow existing convention per directory.

## TypeSpec conventions

**IMPORTANT: Required decorators on every interface:** `@useAuth(HyperFleet.BearerAuth)`, `@tag("ResourceName")`. Every operation must have `@operationId("operationName")` and `@summary("...")`. Missing `@useAuth` causes the generated spec to omit security requirements — this was a real bug (commit `89b9f9b`).

**Service file boilerplate:**
```tsp
import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
// ... model imports ...

using Http;
using OpenAPI;

namespace HyperFleet;

@tag("Resources")
@route("/resources")
@useAuth(HyperFleet.BearerAuth)
interface Resources {
  @get
  @summary("List resources")
  @operationId("getResources")
  getResources(...QueryParams): Body<ResourceList> | Error | BadRequestResponse;
}
```

**Model files** do not declare a namespace or `using` statements — just imports and model definitions.

**Naming:**
- Resources: `Cluster`, `NodePool`, `Resource` (singular)
- Create payloads: `ClusterCreateRequest`, `ResourceCreateRequest`
- Patch payloads: `ClusterPatchRequest`, `ResourcePatchRequest`
- Lists: `ClusterList`, `ResourceList`

**Import order:** TypeSpec library imports first, then relative model/service imports.

**Example files:** Each resource has `example_*.tsp` files for `@example` decorators. Example files in `shared/models/` are imported from their resource's `model.tsp`. Example files in `core/models/` are imported from `main.tsp`. Example files do not declare a namespace.

## Boundaries

- **IMPORTANT:** Never edit files in `schemas/` or `tsp-output-core/` directly — they are generated
- `package.json` version is auto-synced by `build-schema.sh` — do not edit manually
- New service files must be imported in `main.tsp` or they won't compile into the schema

## Gotchas

- `@typespec/rest` and `@typespec/versioning` are in `package.json` but not imported in any source file — they may be transitive requirements. Don't remove without testing.
- Spectral linting in CI uses `--fail-severity warn` — all warnings are treated as errors.
- The `go.mod` at repo root exists so downstream Go services can `go get` this module and read schemas via `embed.FS`. Don't remove it.
- The `BearerAuth` model in `main.tsp` uses lowercase `"bearer"` as a workaround for `kin-openapi` library requirements.
