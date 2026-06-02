import "./model.tsp";
import "../common/model.tsp";

// Example AdapterStatus for validator adapter
const exampleAdapterStatus: AdapterStatus = (#{
  adapter: ExampleAdapter1,
  observed_generation: 1,
  conditions: #[
    #{
      type: ConditionType.Available,
      status: AdapterConditionStatus.True,
      reason: ExampleAdapter1AvailableReason,
      message: ExampleAdapter1AvailableMessage,
      last_transition_time: "2021-01-01T10:00:00Z",
    },
    #{
      type: "Applied",
      status: AdapterConditionStatus.True,
      reason: ExampleAdapter1AppliedReason,
      message: ExampleAdapter1AppliedMessage,
      last_transition_time: "2021-01-01T10:00:00Z",
    },
    #{
      type: "Health",
      status: AdapterConditionStatus.True,
      reason: ExampleAdapter1HealthReason,
      message: ExampleAdapter1HealthMessage,
      last_transition_time: "2021-01-01T10:00:00Z",
    },
    #{
      type: "Finalized",
      status: AdapterConditionStatus.True,
      reason: ExampleAdapter1FinalizedReason,
      message: ExampleAdapter1FinalizedMessage,
      last_transition_time: "2021-01-01T10:00:00Z",
    }
  ],
  metadata: #{
    job_name: "validator-job-abc123",
    job_namespace: "hyperfleet-system",
    attempt: 1,
    started_time: "2021-01-01T10:00:00Z",
    completed_time: "2021-01-01T10:02:00Z",
    duration: "2m",
  },
  data: #{
    validation_results: #{
      total_tests: 30,
      passed: 30,
      failed: 0,
    },
  },
  created_time: "2021-01-01T10:00:00Z",
  last_report_time: "2021-01-01T10:02:00Z",
});

// Example AdapterStatusCreateRequest (for PUT /clusters/{id}/statuses)
const exampleAdapterStatusCreateRequest: AdapterStatusCreateRequest = (#{
  adapter: "validator",
  observed_generation: 1,
  observed_time: "2021-01-01T10:00:00Z",
  conditions: #[
    #{
      type: ConditionType.Available,
      status: AdapterConditionStatus.True,
      reason: ExampleAdapter1AvailableReason,
      message: ExampleAdapter1AvailableMessage,
    },
    #{
      type: "Applied",
      status: AdapterConditionStatus.True,
      reason: ExampleAdapter1AppliedReason,
      message: ExampleAdapter1AppliedMessage,
    },
    #{
      type: "Health",
      status: AdapterConditionStatus.True,
      reason: ExampleAdapter1HealthReason,
      message: ExampleAdapter1HealthMessage,
    },
    #{
      type: "Finalized",
      status: AdapterConditionStatus.True,
      reason: ExampleAdapter1FinalizedReason,
      message: ExampleAdapter1FinalizedMessage,
    }
  ],
  metadata: #{
    job_name: "validator-job-abc123",
    job_namespace: "hyperfleet-system",
    attempt: 1,
    started_time: "2021-01-01T10:00:00Z",
    completed_time: "2021-01-01T10:02:00Z",
    duration: "2m",
  },
  data: #{
    validation_results: #{
      total_tests: 30,
      passed: 30,
      failed: 0,
    },
  },
});

// Example AdapterStatusList response (for GET /clusters/{id}/statuses)
const exampleAdapterStatusList: AdapterStatusList = (#{
  page: 1,
  size: 2,
  total: 2,
  items: #[
    #{
      adapter: ExampleAdapter1,
      observed_generation: 1,
      conditions: #[
        #{
          type: ConditionType.Available,
          status: AdapterConditionStatus.True,
          reason: ExampleAdapter1AvailableReason,
          message: ExampleAdapter1AvailableMessage,
          last_transition_time: "2021-01-01T10:00:00Z",
        },
      ],
      metadata: #{
        job_name: "validator-job-abc123",
        duration: "2m",
      },
      created_time: "2021-01-01T10:00:00Z",
      last_report_time: "2021-01-01T10:02:00Z",
    },
    #{
      adapter: ExampleAdapter2,
      observed_generation: 1,
      conditions: #[
        #{
          type: ConditionType.Available,
          status: AdapterConditionStatus.True,
          reason: ExampleAdapter2AvailableReason,
          message: ExampleAdapter2AvailableMessage,
          last_transition_time: "2021-01-01T10:01:00Z",
        },
      ],
      created_time: "2021-01-01T10:01:00Z",
      last_report_time: "2021-01-01T10:01:30Z",
    },
  ],
});
