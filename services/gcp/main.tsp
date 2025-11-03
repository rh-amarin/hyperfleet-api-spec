import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./cluster/model.tsp";
import "../../shared/clusters/";
import "../../shared/statuses/";
import "../../shared/nodepools/";
import "../../shared/compatibility/";
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
@tagMetadata("Clusters", #{ description: "Cluster resource CRUD operations" })
@tagMetadata( "NodePools", #{ description: "NodePool resource CRUD operations" })
@tagMetadata( "Cluster statuses", #{ description: "Status for Clusters" })
@tagMetadata( "NodePool statuses", #{ description: "Status for NodePools" })
@route("/api/hyperfleet/v1")
namespace HyperFleet;

