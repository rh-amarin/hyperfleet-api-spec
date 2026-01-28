import "../../aliases-core.tsp";
import "../../models/clusters/model.tsp";
import "../../models/common/model.tsp";

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
    conditions: #[
      #{
        type: ConditionType.Ready,
        status: ResourceConditionStatus.True,
        reason: ExampleReadyReason,
        message: ExampleReadyMessage,
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: ConditionType.Available,
        status: ResourceConditionStatus.True,
        reason: ExampleAvailableReason,
        message: ExampleAvailableMessage,
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "Adapter1Successful",
        status: ResourceConditionStatus.True,
        reason: ExampleAdapter1AvaliableReason,
        message: ExampleAdapter1AvaliableMessage,
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "Adapter2Successful",
        status: ResourceConditionStatus.True,
        reason: ExampleAdapter2AvaliableReason,
        message: ExampleAdapter2AvaliableMessage,
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
