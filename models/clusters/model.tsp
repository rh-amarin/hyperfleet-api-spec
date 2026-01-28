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
 * Provides quick overview of all reported conditions.
 */
model ClusterStatus {

  /**
   * List of status conditions for the cluster.
   * 
   * **Mandatory conditions**: 
   * - `type: "Ready"`: Whether all adapters report successfully at the current generation.
   * - `type: "Available"`: Aggregated adapter result for a common observed_generation.   
   * 
   * These conditions are present immediately upon resource creation.
   */
  @minItems(2)
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
