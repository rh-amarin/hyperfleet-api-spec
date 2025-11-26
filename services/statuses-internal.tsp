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
interface ClusterStatusesInternal{

  /**
   * Adapter creates or updates its status report for this cluster.
   * If adapter already has a status, it will be updated (upsert by adapter name).
   *
   * Response includes the full adapter status with all conditions.
   * Adapter should call this endpoint every time it evaluates the cluster.
   *
   */
  @route("")
  @post
  @summary("Create or update adapter status")
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
      | ConflictResponse
      | BadRequestResponse;

}

//@tag("NodePool statuses")
@route("/clusters/{cluster_id}/nodepools/{nodepool_id}/statuses")
interface NodePoolStatusesInternal{

  /**
   * Adapter creates or updates its status report for this nodepool.
   * If adapter already has a status, it will be updated (upsert by adapter name).
   *
   * Response includes the full adapter status with all conditions.
   * Adapter should call this endpoint every time it evaluates the nodepool.
   *
   */
  @route("")
  @post
  @summary("Create or update adapter status")
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
      | ConflictResponse
      | BadRequestResponse;

}
