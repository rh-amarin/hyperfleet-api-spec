import "../../aliases-gcp.tsp";
import "../../models/clusters/model.tsp";

const exampleCluster: Cluster = #{
  kind: "Cluster",
  id: "cluster-123",
  href: "https://api.hyperfleet.com/v1/clusters/cluster-123",
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
  created_at: "2021-01-01T00:00:00Z",
  updated_at: "2021-01-01T00:00:00Z",
  generation: 1,
  status: #{
    phase: "Ready",
    last_transition_time: "2021-01-01T00:00:00Z",
    observed_generation: 1,
    updated_at: "2021-01-01T00:00:00Z",
    adapters: #[
      #{
        adapter: "validator",
        type: "Available",
        status: "True",
        reason: "All validations passed",
        message: "All 30 validation tests passed",
        observed_generation: 1,
        created_at: "2021-01-01T00:00:00Z",
        updated_at: "2021-01-01T00:00:00Z",
      },
      #{
        adapter: "dns",
        type: "Available",
        status: "True",
        reason: "DNS records created",
        message: "custom.domain.com created",
        observed_generation: 1,
        created_at: "2021-01-01T00:00:00Z",
        updated_at: "2021-01-01T00:00:00Z",
      }
    ],
  },
  created_by: "user-123@example.com",
  updated_by: "user-123@example.com",
};