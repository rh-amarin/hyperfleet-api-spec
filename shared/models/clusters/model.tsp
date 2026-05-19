import "@typespec/openapi";
import "../common/model.tsp";
import "../statuses/model.tsp";

using OpenAPI;

model ClusterBase {
  ...APIResource;

  /**
   * Cluster name (unique)
   */
  @minLength(3)
  @maxLength(53)
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
   * - `type: "Reconciled"`: Whether the resource's desired state has been fully reconciled by all adapters at the current generation.
   * - `type: "LastKnownReconciled"`: Sticky cross-generation condition — stays True as long as all required adapters were reconciled at a common observed generation, even if a newer generation is being processed.
   *
   * These conditions are present immediately upon resource creation.
   */
  @minItems(2)
  conditions: ResourceCondition[];
}

@example(exampleCluster)
model Cluster {
  ...ClusterBase;
  ...APIMetadata;

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

@extension("minProperties", 1)
@extension("additionalProperties", false)
@example(exampleClusterPatchRequest)
model ClusterPatchRequest {
  spec?: ClusterSpec;
  labels?: Record<string>;
}

model ClusterList {
  ...List<Cluster>;
}
