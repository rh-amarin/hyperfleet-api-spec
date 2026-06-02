import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../../shared/models/statuses/model.tsp";
import "../../shared/models/common/model.tsp";
import "../../shared/models/nodepools/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@route("/clusters/{cluster_id}/statuses")
@useAuth(HyperFleet.BearerAuth)
@tag("Cluster statuses")
interface ClusterStatuses {
  /**
   * Returns adapter status reports for this cluster
   */
  @route("")
  @get
  @summary("List all adapter statuses for cluster")
  @operationId("getClusterStatuses")
  getClusterStatuses(
    /**
     * Cluster ID
     */
    @path cluster_id: string,
    ...QueryParams
  ): Body<AdapterStatusList>
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse;

  @route("")
  @put
  @summary("Adapter creates or updates cluster status")
  @operationId("putClusterStatuses")
  @doc("Adapters call this endpoint to report the status for a cluster after each evaluation. The adapter's status entry is created if it doesn't exist, or updated if it does (upserted by adapter name). This allows HyperFleet to aggregate multiple adapter perspectives into a unified cluster status.")
  putClusterStatuses(
    /**
     * Cluster ID
     */
    @path cluster_id: string,

    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse;
}

@tag("NodePool statuses")
@route("/clusters/{cluster_id}/nodepools/{nodepool_id}/statuses")
@useAuth(HyperFleet.BearerAuth)
interface NodePoolStatuses {
  /**
   * Returns adapter status reports for this nodepool
   */
  @route("")
  @get
  @summary("List all adapter statuses for nodepools")
  @operationId("getNodePoolsStatuses")
  getNodePoolsStatuses(
    /**
     * Cluster ID
     */
    @path cluster_id: string,
    @path nodepool_id: string,
    ...QueryParams
  ): Body<AdapterStatusList>
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse;

  @route("")
  @put
  @summary("Adapter creates or updates nodepool status")
  @operationId("putNodePoolStatuses")
  @doc("Adapters call this endpoint to report the status for a nodepool after each evaluation. The adapter's status entry is created if it doesn't exist, or updated if it does (upserted by adapter name). This allows HyperFleet to aggregate multiple adapter perspectives into a unified nodepool status.")
  putNodePoolStatuses(
    /**
     * Cluster ID
     */
    @path cluster_id: string,

    /**
     * NodePool ID
     */
    @path nodepool_id: string,

    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse;
}

