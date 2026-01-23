import "../../aliases-gcp.tsp";
import "../../models/nodepools/model.tsp";

const exampleNodePool: NodePool = #{
  kind: "NodePool",
  id: "nodepool-123",
  href: "https://api.hyperfleet.com/v1/nodepools/nodepool-123",
  name: "worker-pool-1",
  labels: #{ environment: "production", pooltype: "worker" },
  generation: 1,
  spec: #{
    platform: #{
      type: "gcp",
      gcp: #{
        machineType: "n1-standard-4",
        diskSize: 100,
        diskType: "pd-standard",
        zones: #["us-central1-a", "us-central1-b"],
        preemptible: false,
        labels: #{
          team: "platform",
          managedby: "hyperfleet",
        },
      },
    },
    nodeCount: 3,
    autoscaling: #{
      enabled: true,
      minNodes: 1,
      maxNodes: 10,
      targetCPUUtilization: 80,
    },
  },
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
    conditions: #[
      #{
        type: ConditionType.Ready,
        status: ResourceConditionStatus.True,
        reason: "ResourceReady",
        message: "All conditions successful for current spec generation",
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: ConditionType.Available,
        status: ResourceConditionStatus.True,
        reason: "ResourceAvailable",
        message: "All conditions successful for observed_generation",
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "ValidationSuccessful",
        status: ResourceConditionStatus.True,
        reason: "All validations passed",
        message: "NodePool validation passed",
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "NodePoolSuccessful",
        status: ResourceConditionStatus.True,
        reason: "NodePool provisioned successfully",
        message: "NodePool has 3 nodes running",
        observed_generation: 1,
        created_time: "2021-01-01T10:01:00Z",
        last_updated_time: "2021-01-01T10:01:00Z",
        last_transition_time: "2021-01-01T10:01:00Z",
      },
    ],
  },
};
