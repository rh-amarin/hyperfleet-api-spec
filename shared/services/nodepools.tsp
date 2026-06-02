import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/nodepools/model.tsp";
import "../models/common/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@tag("NodePools")
@useAuth(HyperFleet.BearerAuth)
interface NodePools {
    /**
     * Returns the list of all nodepools
     */
    @route("/nodepools")
    @get
    @summary("List all nodepools for cluster")
    @operationId("getNodePools")
    getNodePools(...QueryParams): Body<NodePoolList>
      | Error
      | BadRequestResponse
      | UnauthorizedResponse;

    /**
     * Returns the list of all nodepools for a cluster
     */
    @route("/clusters/{cluster_id}/nodepools")
    @get
    @summary("List all nodepools for cluster")
    @operationId("getNodePoolsByClusterId")
    getNodePoolsByClusterId(
        /** Cluster ID */
        @path cluster_id: Identifier,

        ...QueryParams,
    ): Body<NodePoolList>
      | Error
      | BadRequestResponse
      | UnauthorizedResponse;

    /**
     * Create a NodePool for a cluster
     */
    @route("/clusters/{cluster_id}/nodepools")
    @post
    @summary("Create nodepool")
    @operationId("createNodePool")
    createNodePool(
        /** Cluster ID */
        @path cluster_id: string,

        @body body: NodePoolCreateRequest,
    ):
         (CreatedResponse & NodePoolCreateResponse)
         | Error
         | BadRequestResponse
         | UnauthorizedResponse
         | NotFoundResponse
         | ConflictResponse;

    /**
     * Returns specific nodepool
     */
    @route("/clusters/{cluster_id}/nodepools/{nodepool_id}")
    @get
    @summary("Get nodepool by ID")
    @operationId("getNodePoolById")
    getNodePoolById(
        /** Cluster ID */
        @path cluster_id: string,
        /** NodePool ID */
        @path nodepool_id: string,
    ): NodePool
      | Error
      | BadRequestResponse
      | UnauthorizedResponse
      | NotFoundResponse;

    /**
     * Marks the nodepool for deletion by setting deleted_time and deleted_by. Does not affect the parent cluster.
     * Returns the updated nodepool with generation incremented.
     */
    @opExample(#{ returnType: #{ statusCode: 202, nodepool: exampleDeletedNodePool } })
    @route("/clusters/{cluster_id}/nodepools/{nodepool_id}")
    @delete
    @summary("Request nodepool deletion")
    @operationId("deleteNodePoolById")
    deleteNodePoolById(
        /** Cluster ID */
        @path cluster_id: string,
        /** NodePool ID */
        @path nodepool_id: string,
    ): {
      @statusCode statusCode: 202;
      @body nodepool: NodePool;
    } | Error
      | BadRequestResponse
      | UnauthorizedResponse
      | NotFoundResponse;

    /**
     * Patch a specific nodepool within a cluster
     */
    @route("/clusters/{cluster_id}/nodepools/{nodepool_id}")
    @patch
    @summary("Patch nodepool by ID")
    @operationId("patchNodePoolById")
    patchNodePoolById(
        /** Cluster ID */
        @path cluster_id: string,
        /** NodePool ID */
        @path nodepool_id: string,
        @body body: NodePoolPatchRequest,
    ): NodePool
      | Error
      | BadRequestResponse
      | UnauthorizedResponse
      | NotFoundResponse
      | ConflictResponse;
}
