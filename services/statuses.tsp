import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/statuses/model.tsp";
import "../models/common/model.tsp";
import "../models/nodepools/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;
@route("/clusters/{cluster_id}/statuses")
//@tag("Cluster statuses")
interface ClusterStatuses{
  /**
   * Returns current status object for each adapter that has reported status
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
  ): Body< Page<AdapterStatus>> | NotFoundResponse;

  /**
   * Adapter creates its initial status object for this cluster.
   * Returns 409 if adapter already has a status object for this cluster 
   *
   * Response includes the status id and href for future operations.
   * Adapter should store the returned id/href to update its status later.
   *
   */
  @route("")
  @post
  @summary("Create adapter status")
  @operationId("postClusterStatuses")
  postClusterStatuses(
    /**
     * Cluster ID
     */
     @path cluster_id: string,

    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | BadRequestResponse
    | NotFoundResponse
    | ConflictResponse;

}

//@tag("NodePool statuses")
@route("/clusters/{cluster_id}/nodepools/{nodepool_id}/statuses")
interface NodePoolStatuses{
  /**
   * Returns current status object for each adapter that has reported status
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
  ): Body< Page<AdapterStatus>> | NotFoundResponse;

  /**
   * Adapter creates its initial status object for this cluster.
   * Returns 409 if adapter already has a status object for this cluster 
   *
   * Response includes the status id and href for future operations.
   * Adapter should store the returned id/href to update its status later.
   *
   */
  @route("")
  @post
  @summary("Create adapter status")
  @operationId("postNodePoolStatuses")
  postNodePoolStatuses(
    /**
     * Cluster ID
     */
     @path cluster_id: string,
     @path nodepool_id: string,

    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | BadRequestResponse
    | NotFoundResponse
    | ConflictResponse;

}
