import "@typespec/openapi";
import "../common/model.tsp";
import "../statuses/model.tsp";
import "./example_resource.tsp";
import "./example_post.tsp";
import "./example_patch.tsp";

using OpenAPI;

/**
 * Aggregated status of the resource, populated by the status aggregation
 * pipeline from adapter condition reports.
 */
model ResourceStatus {
  conditions: ResourceCondition[];
}

@example(exampleResource)
model Resource {
  /** Resource identifier (UUID v7) */
  id: Identifier;

  /** Entity type discriminator */
  kind: string;

  /** Resource name (unique per kind, or per kind+owner for child entities) */
  @minLength(1)
  @maxLength(253)
  name: string;

  /** Resource URI (computed at creation time) */
  href?: string;

  /** Entity-specific payload, validated at runtime against the entity's spec schema */
  spec: Record<unknown>;

  /** Key-value pairs for filtering and grouping */
  labels?: Record<string>;

  status: ResourceStatus;

  /** Incremented on spec or label changes */
  @minValue(1)
  generation: int32;

  /** Parent resource reference (present only on child entities) */
  owner_references?: ObjectReference;

  /** Non-ownership associations to other resources, keyed by reference type */
  references?: Record<ObjectReference[]>;

  ...APIMetadata;
}

@example(exampleResourceCreateRequest)
model ResourceCreateRequest {
  /** Entity type discriminator */
  kind: string;

  /** Resource name */
  @minLength(1)
  @maxLength(253)
  name: string;

  /** Entity-specific payload */
  spec: Record<unknown>;

  /** Key-value pairs for filtering and grouping */
  labels?: Record<string>;

  /** Non-ownership associations to other resources */
  references?: Record<ObjectReference[]>;
}

@extension("minProperties", 1)
@extension("additionalProperties", false)
@example(exampleResourcePatchRequest)
model ResourcePatchRequest {
  spec?: Record<unknown>;
  labels?: Record<string>;
  references?: Record<ObjectReference[]>;
}

model ResourceList {
  page: int32;
  size: int32;
  total: int64;
  items: Resource[];
}
