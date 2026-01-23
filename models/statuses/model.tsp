import "../common/model.tsp";
import "./example_adapter_status.tsp";

/**
 * Status value for resource conditions
 */
enum ResourceConditionStatus {
    True: "True",
    False: "False",
}

/**
 * Condition in AdapterStatus
 * Used for standard Kubernetes condition types: "Available", "Applied", "Health"
 * Note: observed_generation is at AdapterStatus level, not per-condition,
 * since all conditions in one AdapterStatus share the same observed generation
 */
model AdapterCondition {
  ...ConditionBase;

  status: AdapterConditionStatus;
}


/**
 * Condition data for create/update requests (from adapters)
 * observed_generation and observed_time are now at AdapterStatusCreateRequest level
 */
model ConditionRequest {
  type: string;
  status: AdapterConditionStatus;
  reason?: string;
  message?: string;
}

/**
 * Base fields shared by AdapterStatus and AdapterStatusCreateRequest
 */
model AdapterStatusBase {
  /**
   * Adapter name (e.g., "validator", "dns", "provisioner")
   */
  adapter: string;

  /**
   * Which generation of the resource this status reflects
   */
  observed_generation: int32;

  /**
   * Job execution metadata
   */
  metadata?: {
    job_name?: string;
    job_namespace?: string;
    attempt?: int32;
    @format("date-time") started_time?: string;
    @format("date-time") completed_time?: string;
    duration?: string;
  };

  /**
   * Adapter-specific data (structure varies by adapter type)
   */
  data?: Record<unknown>;
}

/**
 * AdapterStatus represents the complete status report from an adapter
 * Contains multiple conditions, job metadata, and adapter-specific data
 */
@example(exampleAdapterStatus)
model AdapterStatus {
  ...AdapterStatusBase;
  /**
   * Kubernetes-style conditions tracking adapter state
   * Typically includes: Available, Applied, Health
   */
  conditions: AdapterCondition[];

  /**
   * When this adapter status was first created (API-managed)
   */
  @format("date-time") created_time: string;

  /**
   * When this adapter last reported its status (API-managed)
   * Updated every time the adapter POSTs, even if conditions haven't changed
   * Used by Sentinel to detect adapter liveness
   */
  @format("date-time") last_report_time: string;
}

/**
 * Request payload for creating/updating adapter status
 */
@example(exampleAdapterStatusCreateRequest)
model AdapterStatusCreateRequest {
  ...AdapterStatusBase;
  /**
   * When the adapter observed this resource state
   * API will use this to set AdapterStatus.last_report_time
   */
  @format("date-time") observed_time: string;

  conditions: ConditionRequest[];
}

/**
 * List of adapter statuses with pagination metadata
 */
@example(exampleAdapterStatusList)
model AdapterStatusList {
  ...List<AdapterStatus>;
}
