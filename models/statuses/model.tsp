import "../common/model.tsp";
import "./example_adapter_status.tsp";
/** Common data for status objects, part of:
 * - Status entity (stored in DB)
 * - Request payload
 */
model ConditionBase {
  /** Adapter name */
  adapter: string;

  /*
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

  /*
   * Generation of the spec that triggered the adapter work
   */
  observed_generation: int32;

  /** Time when the condition was created
   * - In an adapter reporting conditions `updated_at==created_at`
   * - In the API, `created_at` doesn't change with new updates from adapters
   */
  @format("date-time") created_at: string;

  /** Time when the condition was updated
   */
  @format("date-time") updated_at: string;
}

/** StatusAvailable is the status condition from an adapter that is used by CLM to compute the phase.
 * `phase=ready` when all adaptors report `Available=true`
 */
model ConditionAvailable extends ConditionBase {
  type: "Available";
}

model Condition {
  ...ConditionBase;

  /**
   * When this condition last transitioned (computed by service when status changes)
   */
  last_transition_time?: utcDateTime;
}

model ConditionRequest {
  ...ConditionBase;
}

model AdapterStatusCreateRequest {
  /**
   * Adapter identifier
   */
  adapter: string;

  /**
   * Which cluster generation this status reflects
   */
  observed_generation: int32;

  conditions: Condition[];

  /**
   * Adapter-specific data
   */
  data?: Record<unknown>;

  /**
   * Job execution metadata
   */
  metadata?: Record<unknown>;
}

@example(exampleAdapterStatus)
model AdapterStatus {
  /** Name of the adapter that generated this status (Validator, DNS...) */
  adapter: string;

  /**
   * Which generation for an entity (Clusters, NodePools) was current at the time of creating this status
   */
  observed_generation: int32;

  /**
   * Kubernetes-style conditions tracking adapter state
   */
  conditions: Condition[];

  /**
   * Adapter-specific data (structure varies by adapter type)
   */
  data?: Record<unknown>;

  /**
   * Metadata about the adapter job/execution
   */
  metadata?: {
    job_name?: string;
    job_namespace?: string;
    attempt?: int32;
    started_at?: string;
    completed_at?: string;
    duration?: string;
  };
}
