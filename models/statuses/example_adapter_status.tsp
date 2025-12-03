import "../../models/statuses/model.tsp";

// Example AdapterStatus for validator adapter
const exampleAdapterStatus: AdapterStatus = (#{
  adapter: "validator",
  observed_generation: 1,
  conditions: #[
    #{
      type: "Available",
      status: ConditionStatus.True,
      reason: "All validations passed",
      message: "All 30 validation tests passed",
      last_transition_time: "2021-01-01T10:00:00Z",
    },
    #{
      type: "Applied",
      status: ConditionStatus.True,
      reason: "Validation job applied",
      message: "Validation job applied successfully",
      last_transition_time: "2021-01-01T10:00:00Z",
    },
    #{
      type: "Health",
      status: ConditionStatus.True,
      reason: "All adapter operations completed successfully",
      message: "All adapter runtime operations completed successfully",
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

// Example AdapterStatusCreateRequest (for POST /clusters/{id}/statuses)
const exampleAdapterStatusCreateRequest: AdapterStatusCreateRequest = (#{
  adapter: "validator",
  observed_generation: 1,
  observed_time: "2021-01-01T10:00:00Z",
  conditions: #[
    #{
      type: "Available",
      status: ConditionStatus.True,
      reason: "All validations passed",
      message: "All 30 validation tests passed",
    },
    #{
      type: "Applied",
      status: ConditionStatus.True,
      reason: "Validation job applied",
      message: "Validation job applied successfully",
    },
    #{
      type: "Health",
      status: ConditionStatus.True,
      reason: "All adapter operations completed successfully",
      message: "All adapter runtime operations completed successfully",
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
  kind: "AdapterStatusList",
  page: 1,
  size: 2,
  total: 2,
  items: #[
    #{
      adapter: "validator",
      observed_generation: 1,
      conditions: #[
        #{
          type: "Available",
          status: ConditionStatus.True,
          reason: "All validations passed",
          message: "All 30 validation tests passed",
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
      adapter: "dns",
      observed_generation: 1,
      conditions: #[
        #{
          type: "Available",
          status: ConditionStatus.True,
          reason: "DNS configured",
          message: "DNS records created",
          last_transition_time: "2021-01-01T10:01:00Z",
        },
      ],
      created_time: "2021-01-01T10:01:00Z",
      last_report_time: "2021-01-01T10:01:30Z",
    },
  ],
});