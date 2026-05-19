import "./model.tsp";
import "../../../shared/models/nodepools/model.tsp";

const exampleNodePoolPatchRequest: NodePoolPatchRequest = #{
  spec: #{},
  labels: #{ env: "staging" },
};
