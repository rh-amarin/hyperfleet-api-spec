import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./services/clusters.tsp";
import "./services/statuses.tsp";
import "./services/nodepools.tsp";
// Provider-specific security is imported via aliases.tsp
import "./aliases.tsp";

using Http;
using OpenAPI;

/**
 * HyperFleet API provides simple CRUD operations for managing cluster resources and their status history.
 *
 * **Architecture**: Simple CRUD only, no business logic, no event creation.
 * Sentinel operator handles all orchestration logic.
 * Adapters handle the specifics of managing spec
 *
 */
@service(#{ title: "HyperFleet API" })
@info(#{ version: "1.0.1", contact: #{ name: "HyperFleet Team" }, license: #{ name: "Apache 2.0" ,url: "https://www.apache.org/licenses/LICENSE-2.0"} })
@server("https://hyperfleet.redhat.com", "Production")
@route("/api/hyperfleet/v1")
namespace HyperFleet;

// Override BearerAuth to use lowercase "bearer" as required by kin-openapi
model BearerAuth {
  type: AuthType.http;
  scheme: "bearer";
}

