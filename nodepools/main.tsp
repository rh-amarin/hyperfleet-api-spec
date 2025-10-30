import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./model.tsp";
import "../common/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

@route("/{cluster_id}/nodepools")
@tag("Nodepools")
interface Nodepools {
    /**
     * Returns the list of nodepools
     */
    @get
    @summary("List all nodepools for cluster")
    get_nodepools(
        /** Cluster ID */
        @format("uuid") @path cluster_id: Identifier,
        ...QueryParams
    ): Body<{
        ...Page<Nodepool>;
    }>;

    /**
     *
     */
    @route("/")
    @post
    @summary("Create nodepool")
    create_nodepool(
        /** Cluster ID */
        @format("uuid") @path cluster_id: string,

        @body body: NodepoolCreateRequest,
    ):
        | (CreatedResponse & NodepoolCreateResponse)
        | BadRequestResponse
        | NotFoundResponse
        | ConflictResponse;

    /**
     * Delete nodepool
     *
     *
     */
    @route("/{nodepool_id}")
    @delete
    @summary("Delete nodepool")
    delete_nodepool(
        /** Cluster ID */
        @format("uuid") @path cluster_id: Identifier,

        /** Nodepool ID */
        @format("uuid") @path nodepool_id: Identifier,
    ): NoContentResponse | NotFoundResponse;

    /**
     * Returns specific nodepool
     */
    @route("/{nodepool_id}")
    @get
    @summary("Get nodepool by ID")
    get_nodepool(
        /**
         * Cluster ID
         */
        @format("uuid") @path cluster_id: Identifier,

        /**
         * Nodepool ID
         */
        @format("uuid") @path nodepool_id: Identifier,
    ): Nodepool | NotFoundResponse;

    /**
     * Adapter updates its status object.
     * Service computes lastTransitionTime for conditions when status changes.
     * Service updates lastUpdated timestamp automatically.
     *
     */
    @route("/{nodepool_id}")
    @patch(#{ implicitOptionality: true })
    @summary("Update nodepool")
    patch_nodepool(
        /** Cluster ID */
        @format("uuid") @path cluster_id: Identifier,

        /** Nodepool ID */
        @format("uuid") @path nodepool_id: Identifier,

        @body body: NodepoolUpdateRequest,
    ): Nodepool | BadRequestResponse | NotFoundResponse;
}
