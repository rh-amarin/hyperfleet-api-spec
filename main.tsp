import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./clusters/";
import "./statuses/";
import "./nodepools/";
using Http;
using OpenAPI;
/**
 * HyperFleet API provides simple CRUD operations for managing cluster resources and their status history.
 *
 * **Architecture**: v2 - Simple CRUD only, no business logic, no event creation.
 * Sentinel operator handles all orchestration logic.
 *
 */
@service(#{ title: "HyperFleet API" })
@info(#{ version: "1.0.0", contact: #{ name: "HyperFleet Team" } })
@server("https://api.hyperfleet.example.com", "Production")
@server("https://api.hyperfleet.dev.example.com", "Development")
@tagMetadata("Clusters", #{ description: "Cluster resource CRUD operations" })
@tagMetadata( "Statuses", #{ description: "Cluster status" })
@route("/api/clusters")
namespace HyperFleet;

interface All{}
