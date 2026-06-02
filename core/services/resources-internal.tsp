import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../../shared/models/resource/model.tsp";
import "../../shared/models/common/model.tsp";
import "../../shared/models/statuses/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@tag("Resources")
@route("/resources")
@useAuth(HyperFleet.BearerAuth)
interface Resources {
  /**
   * Returns a paginated list of all resources, optionally filtered by kind, labels, or TSL query.
   */
  @get
  @route("")
  @summary("List resources")
  @operationId("getResources")
  getResources(...QueryParams): Body<ResourceList>
    | Error
    | BadRequestResponse
    | UnauthorizedResponse;

  /**
   * Returns a single resource by its ID.
   */
  @route("/{resource_id}")
  @get
  @summary("Get resource by ID")
  @operationId("getResourceById")
  getResourceById(
    ...SearchParams,
    @path resource_id: string,
  ): Resource
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse;

  /**
   * Create a new resource. Only top-level entity types (no parent) can be created
   * via this endpoint. Child entities must use the nested route under their parent.
   */
  @route("")
  @post
  @summary("Create resource")
  @operationId("postResource")
  postResource(@body body: ResourceCreateRequest): {
    @statusCode statusCode: 201;
    @body resource: Resource;
  } | Error
    | BadRequestResponse
    | UnauthorizedResponse;

  /**
   * Patch a resource by ID. Supports partial updates to spec, labels, and references.
   */
  @route("/{resource_id}")
  @patch
  @summary("Patch resource by ID")
  @operationId("patchResourceById")
  patchResourceById(
    @path resource_id: string,
    @body body: ResourcePatchRequest,
  ): Resource
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse
    | ConflictResponse;

  /**
   * Marks the resource for deletion. Child resources are handled per their
   * OnParentDelete policy (cascade or restrict). Returns 409 if a restrict-policy
   * child exists or if another resource holds a reference to this one.
   */
  @route("/{resource_id}")
  @delete
  @summary("Request resource deletion")
  @operationId("deleteResourceById")
  deleteResourceById(
    @path resource_id: string,
  ): {
    @statusCode statusCode: 202;
    @body resource: Resource;
  } | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse
    | ConflictResponse;

  /**
   * Permanently removes the resource record from the database for a resource stuck in Finalizing state.
   * This is a database-only operation. Requires a reason for audit purposes.
   */
  @route("/{resource_id}/force-delete")
  @post
  @summary("Force-delete a resource")
  @operationId("forceDeleteResource")
  forceDeleteResource(
    @path resource_id: string,
    @body body: ForceDeleteRequest,
  ): {
    @statusCode statusCode: 204;
  } | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse
    | ConflictResponse;
}

@tag("Resource statuses")
@route("/resources/{resource_id}/statuses")
@useAuth(HyperFleet.BearerAuth)
interface ResourceStatuses {
  /**
   * Returns adapter statuses for a resource.
   */
  @route("")
  @get
  @summary("List resource statuses")
  @operationId("getResourceStatuses")
  getResourceStatuses(
    @path resource_id: string,
    ...QueryParams,
  ): Body<AdapterStatusList>
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse;

  @route("")
  @put
  @summary("Adapter creates or updates resource status")
  @operationId("putResourceStatuses")
  @doc("Adapters call this endpoint to report status for a resource after each evaluation. The adapter's status entry is created if it doesn't exist, or updated if it does (upserted by adapter name).")
  putResourceStatuses(
    @path resource_id: string,
    @body body: AdapterStatusCreateRequest,
  ):
    | (CreatedResponse & AdapterStatus)
    | Error
    | BadRequestResponse
    | UnauthorizedResponse
    | NotFoundResponse;
}
