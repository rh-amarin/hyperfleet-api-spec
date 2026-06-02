import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../../shared/models/common/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@tag("Clusters")
@route("/clusters")
@useAuth(HyperFleet.BearerAuth)
interface ClustersForceDelete {
  /**
   * Permanently removes the cluster record from the database for a cluster stuck in Finalizing state.
   * This is a database-only operation. Requires a reason for audit purposes.
   */
  @route("/{cluster_id}/force-delete")
  @post
  @summary("Force-delete a cluster")
  @operationId("forceDeleteCluster")
  forceDeleteCluster(
    /** Cluster ID */
    @path cluster_id: string,
    @body body: ForceDeleteRequest,
  ): {
    @statusCode statusCode: 204;
  } | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse
    | ConflictResponse;
}

@tag("NodePools")
@route("/clusters/{cluster_id}/nodepools")
@useAuth(HyperFleet.BearerAuth)
interface NodePoolsForceDelete {
  /**
   * Permanently removes the nodepool record from the database for a nodepool stuck in Finalizing state.
   * This is a database-only operation. Requires a reason for audit purposes.
   */
  @route("/{nodepool_id}/force-delete")
  @post
  @summary("Force-delete a nodepool")
  @operationId("forceDeleteNodePool")
  forceDeleteNodePool(
    /** Cluster ID */
    @path cluster_id: string,
    /** NodePool ID */
    @path nodepool_id: string,
    @body body: ForceDeleteRequest,
  ): {
    @statusCode statusCode: 204;
  } | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse
    | ConflictResponse;
}
