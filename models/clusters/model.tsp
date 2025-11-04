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

@example(exampleCluster)
model Cluster extends ClusterBase {

  /**
   * Generation field is updated on customer updates, reflecting the version of the "intent" of the customer
   */
  @minValue(1) 
  generation: int32;

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
     * Updated when adapters report status.
     * Note: status.phase provides aggregated view from all adapter conditions.
     */
    phase: "NotReady" | "Ready" | "Failed";

    /**
     * When cluster last transitioned (updated by adapters, used by Sentinel for backoff)
     * Updated when adapters report status if the phase changes
     */
    @format("date-time") last_transition_time: string;

    /**
     * Last generation processed by adapters
     * Updated when adapters report status.
     * This will be the lowest value of each adapter's observed_generation values
     * The phase value is based on this generation
     */
    observed_generation: int32;

    /** Time of the last complete report from adapters
     * Updated when adapters report status.
     * Oldest `updated_at` from the adapter conditions
     */
    @format("date-time") updated_at: string;

    adapters: ConditionAvailable[];
  };

  @format("email") created_by: string;
  @format("email") updated_by: string;
}

@example(exampleClusterCreateRequest)
model ClusterCreateRequest extends ClusterBase {}

model ClusterList extends List {
  items: Cluster[];
}
