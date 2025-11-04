import "../../aliases-gcp.tsp";
import "../../models/clusters/model.tsp";

const exampleClusterCreateRequest: ClusterCreateRequest = #{
  kind: "Cluster",
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
      clusterNetwork: #[#{ cidr: "10.10.0.0/16", hostPrefix: 24 }],
      serviceNetwork: #["10.96.0.0/12"],
    },
    dns: #{ baseDomain: "example.com" },
  },
  created_at: "2021-01-01T00:00:00Z",
  updated_at: "2021-01-01T00:00:00Z",
};
