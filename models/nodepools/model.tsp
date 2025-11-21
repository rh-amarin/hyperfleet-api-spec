import "../common/model.tsp";
import "../statuses/model.tsp";
import "../../aliases.tsp";

model NodePoolBase {
  ...APIResource;
  /**
   * NodePool name (unique in a cluster)
   */
  name: string;

  /** Cluster specification
   * CLM doesn't know how to unmarshall the spec, it only stores and forwards to adapters to do their job
   * But CLM will validate the schema before accepting the request
   */
  spec: NodePoolSpec;
}

/**
 * NodePool status computed from all status conditions.
 *
 * This object is computed by the service and CANNOT be modified directly.
 */
model NodePoolStatus {
  /**
   * Current NodePool phase (native database column).
   * Updated when conditions are reported.
   * Note: status.phase provides aggregated view from all conditions.
   */
  phase: "NotReady" | "Ready" | "Failed";

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
model NodePool extends NodePoolBase{

    ...APICreatedResource;
    owner_references: ObjectReference;

    status: NodePoolStatus;
}

@example(exampleNodePoolCreateRequest)
model NodePoolCreateRequest {
    ...NodePoolBase;
}

model NodePoolCreateResponse {
    ...NodePool
}

model NodePoolList extends List {
  items: NodePool[];
}
