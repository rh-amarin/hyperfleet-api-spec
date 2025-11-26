import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/clusters/model.tsp";
import "../models/common/model.tsp";
import "../models/statuses/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;
//@tag("Clusters")
@route("/clusters")
interface Clusters {
  @get
  @route("")
  @summary("List clusters")
  @operationId("getClusters")
  getClusters(...QueryParams): Body<ClusterList> 
    | Error
    | BadRequestResponse;

  @route("/{cluster_id}")
  @get
  @summary("Get cluster by ID")
  @operationId("getClusterById")
  getClusterById(
    ...SearchParams,
    @path cluster_id: string,
  ): Cluster 
    | Error
    | BadRequestResponse;

  /**
   * Create a new cluster resource.
   *
   * **Note**: The `status` object in the response is read-only and computed by the service.
   * It is NOT part of the request body. Initially, status.phase will be "NotReady" and
   * status.conditions will be empty until status conditions are POSTed.
   *
   */
  @route("")
  @post
  @summary("Create cluster")
  @operationId("postCluster")
  postCluster(@body body: ClusterCreateRequest): 
  {
    @statusCode statusCode: 201;
    @body cluster: Cluster;
  } | Error 
    | BadRequestResponse;

}
