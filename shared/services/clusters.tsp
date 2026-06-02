import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/clusters/model.tsp";
import "../models/common/model.tsp";
import "../models/statuses/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;
@tag("Clusters")
@route("/clusters")
@useAuth(HyperFleet.BearerAuth)
interface Clusters {
  @get
  @route("")
  @summary("List clusters")
  @operationId("getClusters")
  @doc("Returns a list of all clusters.")
  getClusters(...QueryParams): Body<ClusterList>
    | Error
    | BadRequestResponse
    | UnauthorizedResponse;

  @route("/{cluster_id}")
  @get
  @summary("Get cluster by ID")
  @operationId("getClusterById")
  @doc("Returns a single cluster by its ID.")
  getClusterById(
    ...SearchParams,
    @path cluster_id: string,
  ): Cluster
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse;

  /**
   * Create a new cluster resource.
   *
   * **Note**: The `status` object in the response is read-only and computed by the service.
   * It is NOT part of the request body. Initially,
   * status.conditions will include mandatory "LastKnownReconciled" and "Reconciled" conditions.
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
    | BadRequestResponse
    | UnauthorizedResponse
    | ConflictResponse;

  /**
   * Patch a specific cluster by ID
   */
  @route("/{cluster_id}")
  @patch
  @summary("Patch cluster by ID")
  @operationId("patchClusterById")
  patchClusterById(
    /** Cluster ID */
    @path cluster_id: string,
    @body body: ClusterPatchRequest,
  ): Cluster
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse
    | ConflictResponse;

  /**
   * Marks the cluster for deletion by setting deleted_time to the current time, cascades to its nodepools.
   * The cluster remains in the database until it is fully deleted.
   * Returns the updated cluster with generation incremented.
   */
  @opExample(#{ returnType: #{ statusCode: 202, cluster: exampleDeletedCluster } })
  @route("/{cluster_id}")
  @delete
  @summary("Request cluster deletion")
  @operationId("deleteClusterById")
  deleteClusterById(
    @path cluster_id: string,
  ): {
    @statusCode statusCode: 202;
    @body cluster: Cluster;
  } | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse;

}
