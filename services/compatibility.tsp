import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../models/common/model.tsp";

using Http;
using OpenAPI;

namespace HyperFleet;

//@tag("Compatibility")
interface Compatibility {
    /**
     * Returns the list of all nodepools
     */
    @route("/compatibility")
    @get
    @operationId("getCompatibility")
    @useAuth(HyperFleet.BearerAuth)
    getNodePools(...QueryParams): Body<string>;
}
