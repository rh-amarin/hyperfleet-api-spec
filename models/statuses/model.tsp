import "../common/model.tsp";
import "./example_adapter_status.tsp";

/**
 * Base condition fields shared by all condition types
 */
model ConditionBase {
  /**
   * Condition type
   */
  type: string;

  /**
   * Condition status
   */
  status: "True" | "False" | "Unknown";

  /**
   * Machine-readable reason code
   */
  reason?: string;

  /**
   * Human-readable message
   */
  message?: string;

  /**
   * When this condition last transitioned status (API-managed)
   * Only updated when status changes (True/False/Unknown), not when reason/message changes
   */
  @format("date-time") last_transition_time: string;
}

/**
 * Condition in AdapterStatus
 * Used for standard Kubernetes condition types: "Available", "Applied", "Health"
 * Note: observed_generation is at AdapterStatus level, not per-condition,
 * since all conditions in one AdapterStatus share the same observed generation
 */
model AdapterCondition extends ConditionBase {
  // No additional fields - inherits all fields from ConditionBase
}

/**
 * Condition in Cluster/NodePool status
 * Used for semantic condition types: "ValidationSuccessful", "DNSSuccessful", "NodePoolSuccessful", etc.
 * Includes observed_generation and last_updated_time to track adapter-specific state
 */
model ResourceCondition extends ConditionBase {
  /**
   * Generation of the spec that this condition reflects
   */
  observed_generation: int32;

  /**
   * When this condition was first created (API-managed)
   */
  @format("date-time") created_time: string;

  /**
   * When the corresponding adapter last reported (API-managed)
   * Updated every time the adapter POSTs, even if condition status hasn't changed
   * Copied from AdapterStatus.last_report_time
   */
  @format("date-time") last_updated_time: string;
}

/**
 * Condition data for create/update requests (from adapters)
 * observed_generation and observed_time are now at AdapterStatusCreateRequest level
 */
model ConditionRequest {
  type: string;
  status: "True" | "False" | "Unknown";
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
model AdapterStatus extends AdapterStatusBase {
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
model AdapterStatusCreateRequest extends AdapterStatusBase {
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
model AdapterStatusList extends List {
  kind: "AdapterStatusList";
  items: AdapterStatus[];
}
