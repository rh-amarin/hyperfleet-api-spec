import "../../aliases-core.tsp";
import "../../models/clusters/model.tsp";

const exampleCluster: Cluster = #{
  kind: "Cluster",
  id: "cluster-123",
  href: "https://api.hyperfleet.com/v1/clusters/cluster-123",
  name: "cluster-123",
  labels: #{ environment: "production", team: "platform" },
  spec: #{},
  created_time: "2021-01-01T00:00:00Z",
  updated_time: "2021-01-01T00:00:00Z",
  generation: 1,
  status: #{
    phase: ResourcePhase.Ready,
    last_transition_time: "2021-01-01T00:00:00Z",
    observed_generation: 1,
    last_updated_time: "2021-01-01T00:00:00Z",
    conditions: #[
      #{
        type: "ValidationSuccessful",
        status: ConditionStatus.True,
        reason: "All validations passed",
        message: "All 30 validation tests passed",
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "DNSSuccessful",
        status: ConditionStatus.True,
        reason: "DNS configured",
        message: "DNS records created for custom.domain.com",
        observed_generation: 1,
        created_time: "2021-01-01T10:01:00Z",
        last_updated_time: "2021-01-01T10:01:00Z",
        last_transition_time: "2021-01-01T10:01:00Z",
      },
    ],
  },
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
};
