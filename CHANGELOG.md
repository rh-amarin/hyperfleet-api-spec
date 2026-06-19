# Changelog

All notable changes to the HyperFleet API specification will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.22] - 2026-06-18

### Fixed

- Added missing `kind` field to NodePool creation example

## [1.0.21] - 2026-06-02

### Removed

- `kind` property from `ClusterList`, `NodePoolList`, `AdapterStatusList`, and `ResourceList` list response schemas (HYPERFLEET-1143)

## [1.0.20] - 2026-06-02

### Fixed

- Typed error response models (`BadRequestResponse`, `UnauthorizedResponse`, `NotFoundResponse`, `ConflictResponse`) now emit an `application/problem+json` body schema per RFC 9457 (HYPERFLEET-993)
- `UnauthorizedResponse` (401) added to all status and force-delete endpoints
- `ConflictResponse` (409) removed from status create/update endpoints (upsert semantics make conflict impossible)
- Default `Error` response added to status create/update endpoints where it was previously missing

### Changed

- `page` and `pageSize` query parameters have `@minValue(1)` constraints (HYPERFLEET-993)
- Error models scoped to `namespace HyperFleet {}` block to avoid collision with TypeSpec.Http built-ins
- Error example constants extracted to `shared/models/common/example_errors.tsp`

## [1.0.18] - 2026-05-26

### Changed

- Restructured TypeSpec sources into `core/` and `shared/` directories (HYPERFLEET-1103)
- Removed GCP provider from core repository; GCP contracts now live in a dedicated `hyperfleet-api-spec-gcp` repository (HYPERFLEET-1103)
- `build-schema.sh` simplified: no provider argument required, generates core OpenAPI only
- CI/CD workflows updated to reflect new `main.tsp` location at repository root

## [1.0.17] - 2026-05-21

### Added

- Generic `Resource` type with `kind` discriminator and JSONB `spec` field, replacing per-entity model hierarchies for new resource types (HYPERFLEET-1083)
- `ResourceCreateRequest`, `ResourcePatchRequest`, `ResourceList`, `ResourceStatus` types in core contract
- Generic `/resources` CRUD routes in core contract (GET list, GET by ID, POST, PATCH, DELETE) per design doc Section 3.2
- `/channels` and `/channels/{channel_id}/versions` CRUD routes in GCP contract
- `references` field on Resource for non-ownership associations between entities (Section 9)
- `ChannelSpec` validation schema in GCP contract (`is_default`, `enabled_regex`)
- `VersionSpec` validation schema in GCP contract (`raw_version`, `enabled`, `is_default`, `release_image`, `end_of_life_time`)
- `KindChannel` and `KindVersion` kind aliases in GCP contract

### Changed

- `GET /resources/{id}/statuses` and `POST /resources/{id}/force-delete` moved to core contract
- `GET /clusters/{id}/statuses` and `GET /nodepools/{id}/statuses` moved to core contract

## [1.0.16] - 2026-05-20

### Added

- `channelGroup` optional field to `ReleaseSpec` in GCP cluster model (GCP-696)

## [1.0.15] - 2026-05-18

### Added

- `ForceDeleteRequest` model with required `reason` field (HYPERFLEET-1075)
- POST `/clusters/{cluster_id}/force-delete` internal endpoint for force-deleting stuck clusters (HYPERFLEET-1075)
- POST `/clusters/{cluster_id}/nodepools/{nodepool_id}/force-delete` internal endpoint for force-deleting stuck nodepools (HYPERFLEET-1075)

## [1.0.14] - 2026-05-15

### Removed

- Deprecated `Ready` condition type from `ConditionType`, status model documentation, and all examples (HYPERFLEET-1052)
- `ExampleReadyReason` and `ExampleReadyMessage` constants

### Changed

- Search example updated from `status.conditions.Ready` to `status.conditions.Reconciled`
- `postCluster` documentation updated to list only `LastKnownReconciled` and `Reconciled` as mandatory conditions

## [1.0.13] - 2026-05-13

### Removed
- POST endpoints from internal status API (`/clusters/{cluster_id}/statuses` and `/clusters/{cluster_id}/nodepools/{nodepool_id}/statuses`)

### Changed

- Internal status API now uses only PUT endpoints with upsert semantics for adapter status updates
- Improved documentation for PUT endpoints to clarify upsert behavior by adapter name

## [1.0.12] - 2026-05-11

### Fixed

- Aligned condition example reason/message fields with actual aggregation code output (HYPERFLEET-1017)
- Updated condition reason strings to use CamelCase format (`AllAdaptersReconciled`, `ReconciledAll`) instead of full sentences
- Updated condition message strings to match actual aggregation logic output

## [1.0.11] - 2026-05-07

### Added

- CI workflow (`ci.yml`) that runs on every PR and push to main: rebuilds all schemas, checks consistency against committed files, lints with `spectral:oas` ruleset, and enforces version bump against latest release tag
- Go module (`go.mod` + `schemas/schemas.go`) exposing all four generated schemas via `//go:embed` as `embed.FS`, enabling downstream consumers to import versioned schemas as a Go module dependency
- `.spectral.yaml` with `spectral:oas` ruleset for OpenAPI 3.0 linting

### Changed

- Release workflow now triggers automatically on push to main instead of requiring a manual tag push; auto-creates annotated tag from version in `main.tsp` and attaches all four schema artifacts (`core-openapi.yaml`, `core-swagger.yaml`, `gcp-openapi.yaml`, `gcp-swagger.yaml`)
- Bumped `actions/checkout` and `actions/setup-node` to v6
- Renamed aggregated condition `Available` to `LastKnownReconciled` in cluster and nodepool status conditions (HYPERFLEET-1017)
- Updated condition examples and descriptions to reflect `LastKnownReconciled` semantics
- Fixed typo `Avaliable` → `Available` in adapter example constants (HYPERFLEET-971)
- Improved README.md structure to align with HyperFleet documentation standards

### Fixed

- `Error.instance` field format changed from `uri` to `uri-reference` per RFC 9457 (instance identifies a specific occurrence and may be a relative URI reference)
- `build-schema.sh` now resolves `tsp` from `node_modules/.bin/` instead of requiring a global install, eliminating version mismatch between the globally installed compiler and the lockfile-pinned version

## [1.0.10] - 2026-05-05

### Added

- 409 Conflict response to cluster patch (PATCH `/clusters/{cluster_id}`) for soft-deleted cluster rejection
- 409 Conflict response to nodepool create (POST `/clusters/{cluster_id}/nodepools`) for soft-deleted cluster rejection
- 409 Conflict response to nodepool patch (PATCH `/clusters/{cluster_id}/nodepools/{nodepool_id}`) for soft-deleted cluster rejection

## [1.0.9] - 2026-05-04

### Added

- PUT endpoint for cluster adapter statuses (PUT `/clusters/{cluster_id}/statuses`) with upsert semantics
- PUT endpoint for nodepool adapter statuses (PUT `/clusters/{cluster_id}/nodepools/{nodepool_id}/statuses`) with upsert semantics

## [1.0.8] - 2026-04-28

### Added

- "Reconciled" condition type to resource status conditions
- "Finalized" condition type to adapter status conditions

### Fixed

- Inconsistent `observed_generation` values across examples

## [1.0.7] - 2026-04-20

### Added

- PATCH endpoint for clusters (PATCH `/clusters/{cluster_id}`) with `ClusterPatchRequest`
- PATCH endpoint for nodepools (PATCH `/clusters/{cluster_id}/nodepools/{nodepool_id}`) with `NodePoolPatchRequest`

## [1.0.6] - 2026-04-13

### Added

- DELETE endpoint for clusters with soft-delete semantics (returns 202, sets `deleted_time`)
- DELETE endpoint for nodepools with soft-delete semantics and cascade support
- `deleted_time` and `deleted_by` optional fields to API metadata

### Changed

- Renamed `APICreatedResource` model to `APIMetadata` to reflect broader scope

## [1.0.2] - 2026-01-13

### Added

- GitHub Actions workflow for automated releases
- Standard schema component naming convention for provider schemas
- Generation field to NodePool models

### Changed

- Standardized TypeSpec schema definitions with enums and validation enhancements
- Refactored to support oapi-codegen compatibility
- Updated OWNERS file to not block approval by bot

### Fixed

- Release GitHub Action to install tsp compiler

## [1.0.0] - 2025-11-25

First official stable release of the HyperFleet API specification.

### Added

- Complete CRUD operations for clusters, nodepools, and statuses
- Status tracking and reporting with comprehensive history management
- Core API variant with generic cluster spec
- GCP API variant with GCP-specific cluster spec
- Kubernetes-style timestamp conventions
- List-based pagination for resource collections
- Separate public and internal status endpoints
- Interactive API documentation

<!-- Links -->
[Unreleased]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.22...HEAD
[1.0.22]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.21...v1.0.22
[1.0.21]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.20...v1.0.21
[1.0.20]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.18...v1.0.20
[1.0.18]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.17...v1.0.18
[1.0.17]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.16...v1.0.17
[1.0.16]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.15...v1.0.16
[1.0.15]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.14...v1.0.15
[1.0.14]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.13...v1.0.14
[1.0.13]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.12...v1.0.13
[1.0.12]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.11...v1.0.12
[1.0.11]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.10...v1.0.11
[1.0.10]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.9...v1.0.10
[1.0.9]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.8...v1.0.9
[1.0.8]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.7...v1.0.8
[1.0.7]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.6...v1.0.7
[1.0.6]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.2...v1.0.6
[1.0.2]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/compare/v1.0.0...v1.0.2
[1.0.0]: https://github.com/openshift-hyperfleet/hyperfleet-api-spec/releases/tag/v1.0.0
