import "./model.tsp";
import "../../../shared/models/clusters/model.tsp";

const exampleClusterCreateRequest: ClusterCreateRequest = #{
  kind: "Cluster",
  name: "cluster-123",
  labels: #{ environment: "production", team: "platform" },
  spec: #{},
};
