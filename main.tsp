import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./services/clusters.tsp";
import "./services/statuses.tsp";
import "./services/nodepools.tsp";
import "./services/compatibility.tsp";
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
@info(#{ version: "1.0.0", contact: #{ name: "HyperFleet Team" } })
@server("http://localhost:8000", "Development")
@route("/api/hyperfleet/v1")
namespace HyperFleet;

// Override BearerAuth to use lowercase "bearer" as required by kin-openapi
model BearerAuth {
  type: AuthType.http;
  scheme: "bearer";
}

