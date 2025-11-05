import "../../aliases-core.tsp";
import "../../models/clusters/model.tsp";

const exampleClusterCreateRequest: ClusterCreateRequest = #{
  kind: "Cluster",
  name: "cluster-123",
  labels: #{ environment: "production", team: "platform" },
  spec: #{ coreProperty1: "coreValue1", coreProperty2: "coreValue2" },
};
