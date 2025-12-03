import "../../aliases-core.tsp";
import "../../models/nodepools/model.tsp";

const exampleNodePool: NodePool = #{
  kind: "NodePool",
  id: "nodepool-123",
  href: "https://api.hyperfleet.com/v1/nodepools/nodepool-123",
  name: "worker-pool-1",
  labels: #{ environment: "production", pooltype: "worker" },
  spec: #{},
  created_time: "2021-01-01T00:00:00Z",
  updated_time: "2021-01-01T00:00:00Z",
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
  owner_references: #{
    id: "cluster-123",
    kind: "Cluster",
    href: "https://api.hyperfleet.com/v1/clusters/cluster-123",
  },
  status: #{
    phase: ResourcePhase.Ready,
    last_transition_time: "2021-01-01T10:00:00Z",
    observed_generation: 1,
    last_updated_time: "2021-01-01T10:02:00Z",
    conditions: #[
      #{
        type: "ValidationSuccessful",
        status: ConditionStatus.True,
        reason: "All validations passed",
        message: "NodePool validation passed",
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "NodePoolSuccessful",
        status: ConditionStatus.True,
        reason: "NodePool provisioned successfully",
        message: "NodePool has been scaled to desired count",
        observed_generation: 1,
        created_time: "2021-01-01T10:01:00Z",
        last_updated_time: "2021-01-01T10:01:00Z",
        last_transition_time: "2021-01-01T10:01:00Z",
      },
    ],
  },
};
