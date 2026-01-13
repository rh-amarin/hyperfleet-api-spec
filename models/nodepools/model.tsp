import "../common/model.tsp";
import "../statuses/model.tsp";
import "../../aliases.tsp";

model NodePoolBase {
  ...APIResource;

  /**
   * NodePool name (unique in a cluster)
   */
  @minLength(3)
  @maxLength(63)
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
  phase: ResourcePhase;

  /**
   * Last generation processed
   * Updated when conditions are reported.
   * This will be the lowest value of each condition's observed_generation values
   * The phase value is based on this generation
   */
  @minValue(1)
  observed_generation: int32;

  /**
   * When NodePool last transitioned (used by Sentinel for backoff)
   */
  @format("date-time") last_transition_time: string;

  /** Time of the last update
   * Updated when conditions are reported.
   * Computed as min(conditions[].last_updated_time) to detect stale adapters.
   * Uses earliest (not latest) timestamp to ensure Sentinel can detect if any adapter has stopped reporting.
   */
  @format("date-time") last_updated_time: string;

  conditions: ResourceCondition[];
}

@example(exampleNodePool)
model NodePool {
  ...NodePoolBase;
  ...APICreatedResource;

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

model NodePoolCreateResponse {
  ...NodePool;
}

model NodePoolList {
  ...List<NodePool>;
}
