import "../common/model.tsp";
import "../statuses/model.tsp";
import "../../aliases.tsp";

model ClusterBase extends APIResource {
  kind: string = "Cluster";

  /**
   * Cluster name (unique)
   */
  @minLength(1)
  @maxLength(63)
  @pattern("^[a-z0-9-]+$")
  name: string;

  /** Cluster specification
   * CLM doesn't know how to unmarshall the spec, it only stores and forwards to adapters to do their job
   * But CLM will validate the schema before accepting the request
   */
  spec: ClusterSpec;
}

/**
 * Cluster status computed from all status conditions.
 *
 * This object is computed by the service and CANNOT be modified directly.
 * It is aggregated from condition updates posted to `/clusters/{id}/statuses`.
 *
 * Provides quick overview of all reported conditions and aggregated phase.
 */
model ClusterStatus {
  /**
   * Current cluster phase (native database column).
   * Updated when conditions are reported.
   * Note: status.phase provides aggregated view from all conditions.
   */
  phase: "NotReady" | "Ready" | "Failed";

  /**
   * When cluster last transitioned (used by Sentinel for backoff)
   * Updated when conditions are reported if the phase changes
   */
  @format("date-time") last_transition_time: string;

  /**
   * Last generation processed
   * Updated when conditions are reported.
   * This will be the lowest value of each condition's observed_generation values
   * The phase value is based on this generation
   */
  observed_generation: int32;

  /** Time of the last update
   * Updated when conditions are reported.
   * Computed as min(conditions[].last_updated_time) to detect stale adapters.
   * Uses earliest (not latest) timestamp to ensure Sentinel can detect if any adapter has stopped reporting.
   */
  @format("date-time") last_updated_time: string;

  conditions: ResourceCondition[];
}

@example(exampleCluster)
model Cluster extends ClusterBase   {
...APICreatedResource;
  /**
   * Generation field is updated on customer updates, reflecting the version of the "intent" of the customer
   */
  @minValue(1)
  generation: int32;

  status: ClusterStatus;

}

@example(exampleClusterCreateRequest)
model ClusterCreateRequest extends ClusterBase {}

model ClusterList extends List {
  items: Cluster[];
}
