import "./model.tsp";
import "../../../shared/models/nodepools/model.tsp";

const exampleNodePoolCreateRequest: NodePoolCreateRequest = #{
  name: "worker-pool-1",
  labels: #{ environment: "production", pooltype: "worker" },
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
};
