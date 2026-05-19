import "@typespec/openapi";
import "../common/model.tsp";
import "../statuses/model.tsp";

using OpenAPI;

model NodePoolBase {
  ...APIResource;

  /**
   * NodePool name (unique in a cluster)
   */
  @minLength(3)
  @maxLength(15)
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  name: string;

  spec: NodePoolSpec;
}

/**
 * NodePool status computed from all status conditions.
 *
 * This object is computed by the service and CANNOT be modified directly.
 */
model NodePoolStatus {

  /**
   * List of status conditions for the nodepool.
   *
   * **Mandatory conditions**:
   * - `type: "Reconciled"`: Whether the resource's desired state has been fully reconciled by all adapters at the current generation.
   * - `type: "LastKnownReconciled"`: Sticky cross-generation condition — stays True as long as all required adapters were reconciled at a common observed generation, even if a newer generation is being processed.
   *
   * These conditions are present immediately upon resource creation.
   */
  @minItems(2)
  conditions: ResourceCondition[];
}

@example(exampleNodePool)
model NodePool {
  ...NodePoolBase;
  ...APIMetadata;

  /**
   * Generation field is updated on customer updates, reflecting the version of the "intent" of the customer
   */
  @minValue(1)
  generation: int32;

  owner_references: ObjectReference;
  status: NodePoolStatus;
}

@example(exampleNodePoolCreateRequest)
model NodePoolCreateRequest {
  ...NodePoolBase;
}

@extension("minProperties", 1)
@extension("additionalProperties", false)
@example(exampleNodePoolPatchRequest)
model NodePoolPatchRequest {
  spec?: NodePoolSpec;
  labels?: Record<string>;
}

model NodePoolCreateResponse {
  ...NodePool;
}

model NodePoolList {
  ...List<NodePool>;
}
