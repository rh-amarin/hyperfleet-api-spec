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

  /**
   * List of status conditions for the nodepool.
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
