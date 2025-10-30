import "../common/model.tsp";
/** Common data for status objects, part of:
 * - Status entity (stored in DB)
 * - Request payload
 */
model ConditionBase {
  /*
   * Adapter name
   */
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
  observed_generation: integer;

  created_at: utcDateTime;
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

model ConditionRequest{
  ...ConditionBase;
}

model AdapterStatusCreateRequest {
  /**
   * Adapter identifier
   */
  adapter_name: string;

  /**
   * Which cluster generation this status reflects
   */
  observed_generation: integer;

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

model AdapterStatusUpdateRequest {
  /**
   * Update observed generation
   */
  observed_generation?: integer;

  /**
   * Update conditions (service computes lastTransitionTime)
   */
  conditions?: {
    type: string;
    status: "True" | "False" | "Unknown";
    reason?: string;
    message?: string;
  }[];

  /**
   * Update adapter-specific data
   */
  data?: Record<unknown>;

  /**
   * Update job metadata
   */
  metadata?: Record<unknown>;
}

model AdapterStatus {
  ...APIResource<KindStatus>;

  /** Name of the adapter that generated this status (Validator, DNS...) */
  adapter_name: string;

  /** Reference to the cluster to which this adapter status pertains */
  owner_references: APIResource<KindCluster>;
  /**
   * Which generation for an entity (Clusters, NodePools) was current at the time of creating this status
   */
  observed_generation: integer;

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
    attempt?: integer;
    started_at?: utcDateTime;
    completed_at?: utcDateTime;
    duration?: string;
  };

  /**
   * When this status was last updated (computed by service)
   */
  last_updated: utcDateTime;

  /**
   * When adapter first created this status
   */
  created_at: utcDateTime;

}
