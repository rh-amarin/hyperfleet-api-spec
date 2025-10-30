import "../common/model.tsp";
import "../statuses/model.tsp";

model ClusterBase {
  ...APIResource<KindCluster>;
  /**
   * Cluster name (unique)
   */
  name: string;

  /** Cluster specification
   * CLM doesn't know how to unmarshall the spec, it only stores and forwards to adapters to do their job
   * But CLM will validate the schema before accepting the request
   */
  spec: Record<unknown>;
}
model Cluster {
  ...ClusterBase;

  /**
   * Generation field is updated on customer updates, reflecting the version of the "intent" of the customer
   */
  generation: integer;

  /**
   * Cluster status aggregation from all adapters.
   *
   * This object is computed by the service and CANNOT be modified directly.
   * It is aggregated from adapter status updates posted to `/clusters/{id}/statuses`.
   *
   * Provides quick overview of which adapters have reported and aggregated phase.
   *
   */
  status: {
    /**
     * Current cluster phase (native database column).
     * Updated when adapters POST status. Used by Sentinel for queries.
     * Note: status.phase provides aggregated view from all adapter conditions.
     */
    phase: "Pending" | "Ready" | "Failed";

    /**
     * Last generation processed by adapters
     * This will be the lowest value of each adapter's observed_generation values
     */
    observed_generation: integer;

    /**
     * When cluster last transitioned (updated by adapters, used by Sentinel for backoff)
     */
    last_transition_time: utcDateTime;

    adapters: ConditionAvailable[];
  };

  created_at: utcDateTime;
  updated_at: utcDateTime;
  created_by: string;
  updated_by: string;
}

model ClusterUpdateRequest {
  ...ClusterBase;
}

model ClusterCreateRequest {
  ...ClusterBase;
}
