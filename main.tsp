import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./core/models/cluster/model.tsp";
import "./core/models/cluster/example_cluster.tsp";
import "./core/models/cluster/example_post.tsp";
import "./core/models/cluster/example_patch.tsp";
import "./core/models/nodepool/model.tsp";
import "./core/models/nodepool/example_nodepool.tsp";
import "./core/models/nodepool/example_post.tsp";
import "./core/models/nodepool/example_patch.tsp";
import "./core/services/statuses-internal.tsp";
import "./core/services/resources-internal.tsp";

import "./shared/services/clusters.tsp";
import "./shared/services/nodepools.tsp";
import "./core/services/force-delete-internal.tsp";

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
@info(#{
  version: "1.0.21",
  contact: #{
    name: "HyperFleet Team",
    url: "https://github.com/openshift-hyperfleet",
  },
  license: #{
    name: "Apache 2.0",
    url: "https://www.apache.org/licenses/LICENSE-2.0",
  },
})
@server("https://hyperfleet.redhat.com", "Production")
@route("/api/hyperfleet/v1")
namespace HyperFleet;

// Override BearerAuth to use lowercase "bearer" as required by kin-openapi
model BearerAuth {
  type: AuthType.http;
  scheme: "bearer";
}
