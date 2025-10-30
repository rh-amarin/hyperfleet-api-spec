import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./model.tsp";

import "../statuses/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;
@route("/")
@tag("Clusters")
interface Clusters {
  @get
  @summary("List clusters")
  get_clusters(...QueryParams): Body<Page<Cluster>>;

  @route("/{cluster_id}")
  @get
  @summary("Get cluster by ID")
  get_cluster_by_id(
    @format("uuid") @path cluster_id: string,
  ): Cluster | NotFoundResponse;

  /**
   * Create a new cluster resource.
   *
   * **Note**: The `status` object in the response is read-only and computed by the service.
   * It is NOT part of the request body. Initially, status.phase will be "Pending" and
   * status.adapters will be empty until adapters POST their status.
   *
   */
  @route("/")
  @post
  @summary("Create cluster")
  post_cluster(@body body: ClusterCreateRequest): (CreatedResponse &
    Cluster) | BadRequestResponse;

  @route("/{cluster_id}")
  @delete
  @summary("Delete cluster")
  delete_cluster(
    @format("uuid") @path cluster_id: string,
  ): NoContentResponse | NotFoundResponse;

  /**
   * Updates cluster spec and increments generation field.
   *
   * **Note**: The `status` object is read-only and CANNOT be modified via this endpoint.
   * Status is aggregated from adapter status updates via `/clusters/{id}/statuses` endpoints.
   * Only spec fields (name, region) can be updated here.
   *
   */
  @route("/{cluster_id}")
  @patch(#{ implicitOptionality: true })
  @summary("Update cluster")
  patch_cluster(
    @format("uuid") @path cluster_id: string,
    @body body: ClusterUpdateRequest,
  ): Cluster | NotFoundResponse;
}
