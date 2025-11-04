import "../common/model.tsp";
import "../statuses/model.tsp";

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
  spec: Record<unknown>;
}
model NodePool {
    ...NodePoolBase;
    owner_references: ObjectReference;

    status: {
        /**
         * Current NodePool phase (native database column).
         * Updated when adapters report status.
         * Note: status.phase provides aggregated view from all adapter conditions.
         */
        phase: "NotReady" | "Ready" | "Failed";

        /**
         * Last generation processed by adapters
         * Updated when adapters report status.
         * This will be the lowest value of each adapter's observed_generation values
         * The phase value is based on this generation
         */
        observed_generation: int32;

        /**
         * When NodePool last transitioned (updated by adapters, used by Sentinel for backoff)
         */
        @format("date-time") last_transition_time: string;

        /** Time of the last complete report from adapters
         * Updated when adapters report status.
         * Oldest `updated_at` from the adapter conditions
         */
        @format("date-time") updated_at: string;

        adapters: ConditionAvailable[];
    };
}

model NodePoolCreateRequest {
    ...NodePoolBase;
}

model NodePoolCreateResponse {
    ...NodePool
}
