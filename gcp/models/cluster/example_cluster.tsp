import "./model.tsp";
import "../../../shared/models/clusters/model.tsp";
import "../../../shared/models/common/model.tsp";

const exampleCluster: Cluster = #{
  kind: "Cluster",
  id: "019466a0-8f8e-7abc-9def-0123456789ab",
  href: "https://api.hyperfleet.com/v1/clusters/019466a0-8f8e-7abc-9def-0123456789ab",
  name: "cluster-123",
  labels: #{ environment: "production", team: "platform" },
  spec: #{
    platform: #{
      type: "gcp",
      gcp: #{
        projectID: "project-123",
        region: "us-central1",
        zone: "us-central1-a",
        network: "network-123",
        subnet: "subnet-123",
      },
    },
    release: #{
      image: "registry.redhat.io/openshift4/ose-cluster-version-operator:v4.14.0",
      version: "4.14.0",
    },
    networking: #{
      clusterNetwork: #[ #{ cidr: "10.10.0.0/16", hostPrefix: 24 } ],
      serviceNetwork: #["10.96.0.0/12"],
    },
    dns: #{
      baseDomain: "example.com",
    },
  },
  generation: 1,
  status: #{
    conditions: #[
      #{
        type: ConditionType.Reconciled,
        status: ResourceConditionStatus.True,
        reason: ExampleReconciledReason,
        message: ExampleReconciledMessage,
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: ConditionType.LastKnownReconciled,
        status: ResourceConditionStatus.True,
        reason: ExampleLastKnownReconciledReason,
        message: ExampleLastKnownReconciledMessage,
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "Adapter1Successful",
        status: ResourceConditionStatus.True,
        reason: ExampleAdapter1AvailableReason,
        message: ExampleAdapter1AvailableMessage,
        observed_generation: 1,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "Adapter2Successful",
        status: ResourceConditionStatus.True,
        reason: ExampleAdapter2AvailableReason,
        message: ExampleAdapter2AvailableMessage,
        observed_generation: 1,
        created_time: "2021-01-01T10:01:00Z",
        last_updated_time: "2021-01-01T10:01:00Z",
        last_transition_time: "2021-01-01T10:01:00Z",
      }
    ],
  },
  created_time: "2021-01-01T00:00:00Z",
  updated_time: "2021-01-01T10:02:00Z",
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
};

const exampleDeletedCluster: Cluster = #{
  kind: "Cluster",
  id: "019466a0-8f8e-7abc-9def-0123456789ab",
  href: "https://api.hyperfleet.com/v1/clusters/019466a0-8f8e-7abc-9def-0123456789ab",
  name: "cluster-123",
  labels: #{ environment: "production", team: "platform" },
  spec: #{
    platform: #{
      type: "gcp",
      gcp: #{
        projectID: "project-123",
        region: "us-central1",
        zone: "us-central1-a",
        network: "network-123",
        subnet: "subnet-123",
      },
    },
    release: #{
      image: "registry.redhat.io/openshift4/ose-cluster-version-operator:v4.14.0",
      version: "4.14.0",
    },
    networking: #{
      clusterNetwork: #[ #{ cidr: "10.10.0.0/16", hostPrefix: 24 } ],
      serviceNetwork: #["10.96.0.0/12"],
    },
    dns: #{
      baseDomain: "example.com",
    },
  },
  generation: 2,
  status: #{
    conditions: #[
      #{
        type: ConditionType.Reconciled,
        status: ResourceConditionStatus.True,
        reason: ExampleReconciledReason,
        message: ExampleReconciledMessage,
        observed_generation: 2,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: ConditionType.LastKnownReconciled,
        status: ResourceConditionStatus.True,
        reason: ExampleLastKnownReconciledReason,
        message: ExampleLastKnownReconciledMessage,
        observed_generation: 2,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "Adapter1Successful",
        status: ResourceConditionStatus.True,
        reason: ExampleAdapter1AvailableReason,
        message: ExampleAdapter1AvailableMessage,
        observed_generation: 2,
        created_time: "2021-01-01T10:00:00Z",
        last_updated_time: "2021-01-01T10:00:00Z",
        last_transition_time: "2021-01-01T10:00:00Z",
      },
      #{
        type: "Adapter2Successful",
        status: ResourceConditionStatus.True,
        reason: ExampleAdapter2AvailableReason,
        message: ExampleAdapter2AvailableMessage,
        observed_generation: 2,
        created_time: "2021-01-01T10:01:00Z",
        last_updated_time: "2021-01-01T10:01:00Z",
        last_transition_time: "2021-01-01T10:01:00Z",
      }
    ],
  },
  created_time: "2021-01-01T00:00:00Z",
  updated_time: "2021-01-01T10:02:00Z",
  deleted_time: "2021-01-01T10:05:00Z",
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
  deleted_by: "user-123@example.com",
};
