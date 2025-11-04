import "../../models/statuses/model.tsp";
const exampleAdapterStatus: AdapterStatus = (#{
  adapter: "validator",
  observed_generation: 1,
  conditions: #[
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
      adapter: "validator",
      type: "Applied",
      status: "True",
      reason: "Validation job applied",
      message: "Validation job applied successfully",
      observed_generation: 1,
      created_at: "2021-01-01T00:00:00Z",
      updated_at: "2021-01-01T00:00:00Z",
    },
    #{
      adapter: "validator",
      type: "Health",
      status: "True",
      reason: "Validation job healthy",
      message: "Validation job is healthy",
      observed_generation: 1,
      created_at: "2021-01-01T00:00:00Z",
      updated_at: "2021-01-01T00:00:00Z",
    }
  ],
  data: #{
    providerProperty1: "providerValue1",
    providerProperty2: "providerValue2",
  },
  metadata: #{
    job_name: "validator-job",
    job_namespace: "default",
    attempt: 1,
    started_at: "2021-01-01T00:00:00Z",
    completed_at: "2021-01-01T00:00:00Z",
    duration: "10s",
  },
});