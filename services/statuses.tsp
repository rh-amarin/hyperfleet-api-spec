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
    | NotFoundResponse
    | BadRequestResponse;


}

//@tag("NodePool statuses")
@route("/clusters/{cluster_id}/nodepools/{nodepool_id}/statuses")
interface NodePoolStatuses{
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
    | BadRequestResponse;

}
