import "../common/model.tsp";
import "../statuses/model.tsp";
import "../../aliases.tsp";

model ClusterBase {
  ...APIResource;

  /**
   * Cluster name (unique)
   */
  @minLength(3)
  @maxLength(63)
  @pattern("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$")
  name: string;

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
  phase: ResourcePhase;

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
model Cluster {
  ...ClusterBase;
  ...APICreatedResource;

  /**
   * Generation field is updated on customer updates, reflecting the version of the "intent" of the customer
   */
  @minValue(1)
  generation: int32;

  status: ClusterStatus;
}

@example(exampleClusterCreateRequest)
model ClusterCreateRequest  {
    ...ClusterBase;
}

model ClusterList {
  ...List<Cluster>;
}
