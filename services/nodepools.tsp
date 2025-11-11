import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/nodepools/model.tsp";
import "../models/common/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

//@tag("NodePools")
interface NodePools {
    /**
     * Returns the list of all nodepools
     */
    @route("/nodepools")
    @get
    @summary("List all nodepools for cluster")
    @operationId("getNodePools")
    getNodePools(...QueryParams): Body<Page<NodePool>> | Error;

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
    ): Body<Page<NodePool>> | Error;

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
         | Error;
}
