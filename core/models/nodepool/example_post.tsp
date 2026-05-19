import "./model.tsp";
import "../../../shared/models/nodepools/model.tsp";

const exampleNodePoolCreateRequest: NodePoolCreateRequest = #{
  name: "worker-pool-1",
  labels: #{ environment: "production", pooltype: "worker" },
  spec: #{},
};
