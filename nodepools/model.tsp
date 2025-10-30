import "../common/model.tsp";
import "../statuses/model.tsp";
model NodePoolSpec {
    provider: string;
}

model ProviderNodePoolSpec {
    schema: string;
    data: unknown;
}

model Nodepool {
    ...APIResource<KindNodePool>;
    owner_references: APIResourceReference<KindCluster>;

    /** Name of the nodepool */
    name: string;

    /** NodePool specification */
    spec: Record<unknown>;

    status: {
        /**
         * Last generation processed by adapters
         * This will be the lowest value of each adapter's observed_generation values
         */
        observed_generation: integer;

        /**
         * When NodePool last transitioned (updated by adapters, used by Sentinel for backoff)
         */
        last_transition_time: utcDateTime;

        adapters: ConditionAvailable[];
    };
}

model NodepoolCreateRequest {}

model NodepoolCreateResponse {}

model NodepoolUpdateRequest {}
