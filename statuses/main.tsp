import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;
@route("/{cluster_id}/statuses")
@tag("Statuses")
interface Statuses{
  /**
   * Returns current status object for each adapter that has reported status
   */
  @route("/")
  @get
  @summary("List all adapter statuses for cluster")
  get_statuses(
    /**
     * Cluster ID
     */
    @format("uuid") @path cluster_id: string,
    ...QueryParams
  ): Body< Page<AdapterStatus>> | NotFoundResponse;

  /**
   * Adapter creates its initial status object for this cluster.
   * Returns 409 if adapter already has a status object for this cluster (use PATCH to update).
   *
   * Response includes the status UUID and href for future PATCH operations.
   * Adapter should store the returned id/href to update its status later.
   *
   */
  @route("/")
  @post
  @summary("Create adapter status")
  post_statuses(
    /**
     * Cluster ID
     */
    @format("uuid") @path cluster_id: string,

    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | BadRequestResponse
    | NotFoundResponse
    | ConflictResponse;

  /**
   * Delete adapter status resource.
   *
   * This removes the adapter's status from the cluster and updates the cluster's
   * status.adapters array. Use when:
   * - Adapter is being removed/disabled
   * - Cleaning up test data
   * - Recovering from errors (delete then POST new status)
   *
   * **Note**: Deleting adapter status does NOT delete the cluster.
   *
   */
  @route("/{status_id}")
  @delete
  @summary("Delete adapter status")
  delete_status(
    /**
     * Cluster ID
     */
    @format("uuid") @path cluster_id: string,

    /**
     * Status ID
     */
    @format("uuid") @path status_id: string,
  ): NoContentResponse | NotFoundResponse;

  /**
   * Returns specific adapter status resource
   */
  @route("/{status_id}")
  @get
  @summary("Get adapter status by ID")
  get_status_by_id(
    /**
     * Cluster ID
     */
    @format("uuid") @path cluster_id: string,

    /**
     * Status ID
     */
    @format("uuid") @path status_id: string,
  ): AdapterStatus | NotFoundResponse;

  /**
   * Adapter updates its status object.
   * Service computes lastTransitionTime for conditions when status changes.
   * Service updates lastUpdated timestamp automatically.
   *
   */
  @route("/{status_id}")
  @patch(#{ implicitOptionality: true })
  @summary("Update adapter status")
  patch_statuses(
    /**
     * Cluster ID
     */
    @format("uuid") @path cluster_id: string,

    /**
     * Status ID
     */
    @format("uuid") @path status_id: string,

    @body body: AdapterStatusUpdateRequest,
  ): AdapterStatus | BadRequestResponse | NotFoundResponse;
}
