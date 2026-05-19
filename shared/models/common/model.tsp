import "@typespec/http";
import "@typespec/openapi";
using Http;
using OpenAPI;

/** Resource identifier in RFC4122 UUID v7 format (time-ordered, e.g., "019466a0-8f8e-7abc-9def-0123456789ab") */
alias Identifier = string;

alias KindCluster = "Cluster";
alias KindClusterStatus = "ClusterStatus";
alias KindNodePoolStatus = "NodePoolStatus";
alias KindNodePool = "NodePool";

model ID {
    /** Resource identifier */
    id?: Identifier;
}

model ObjectReference {
    ...ID;

    /** Resource kind */
    kind?: string;

    /** Resource URI */
    href?: string;
}
model ObjectReference2<Kind> {
    ...ID;

    /** Resource kind */
    kind: Kind;

    /** Resource URI */
    href: string;
}

/**
 * Field-level validation error detail
 */
model ValidationError {
    /** JSON path to the field that failed validation */
    @example("spec.name")
    field: string;

    /** The invalid value that was provided (if safe to include) */
    value?: unknown;

    /** The validation constraint that was violated */
    @example("required")
    constraint?: "required" | "min" | "max" | "min_length" | "max_length" | "pattern" | "enum" | "format" | "unique";

    /** Human-readable error message for this field */
    @example("Cluster name is required")
    message: string;
}

/**
 * RFC 9457 Problem Details error format with HyperFleet extensions
 */
@defaultResponse
model Error {
    @header contentType: "application/problem+json";
    /** URI reference identifying the problem type */
    @format("uri")
    @example("https://api.hyperfleet.io/errors/validation-error")
    type: string;

    /** Short human-readable summary of the problem */
    @example("Validation Failed")
    title: string;

    /** HTTP status code */
    @example(400)
    status: integer;

    /** Human-readable explanation specific to this occurrence */
    @example("The cluster name field is required")
    detail?: string;

    /** URI reference for this specific occurrence */
    @format("uri-reference")
    @example("/api/hyperfleet/v1/clusters")
    instance?: string;

    /** Machine-readable error code in HYPERFLEET-CAT-NUM format */
    @example("HYPERFLEET-VAL-001")
    code?: string;

    /** RFC3339 timestamp of when the error occurred */
    @format("date-time")
    @example("2024-01-15T10:30:00Z")
    timestamp?: string;

    /** Distributed trace ID for correlation */
    @example("abc123def456")
    trace_id?: string;

    /** Field-level validation errors (for validation failures) */
    errors?: ValidationError[];
}

model ErrorResponse<ErrorCode> {
    @statusCode statusCode: ErrorCode;
    @header contentType: "application/problem+json";
    @body error: Error;
}

model APIResource {
  ...ObjectReference;
    /** labels for the API resource as pairs of name:value strings */
    labels?: Record<string>;
}
model APIMetadata {
    @doc("Timestamp when the resource was created")
    @format("date-time") created_time: string;

    @doc("Timestamp when the resource was last updated")
    @format("date-time") updated_time: string;

    @doc("Identity that created the resource")
    @format("email") created_by: string;

    @doc("Identity that last updated the resource")
    @format("email") updated_by: string;

    @doc("Timestamp when deletion was requested; omitted if not marked for deletion")
    @format("date-time") deleted_time?: string;

    @doc("Identity that requested deletion; omitted if not marked for deletion")
    @format("email") deleted_by?: string;
}

model Page<Kind> {
    page: int32;
    size: int32;
    total: int32;
    items: Kind[];
}

enum OrderDirection {
    asc,
    desc,
}

model SearchParams {
    /** Filter results using TSL (Tree Search Language) query syntax.
     * Examples: `status.conditions.Reconciled='True'`, `name in ('c1','c2')`, `labels.region='us-east'` */
    @query
    search?: string;
}

model QueryParams {
    ...SearchParams;
    @query
    page?: int32 = 1;

    @query
    pageSize?: int32 = 20;

    @query
    orderBy?: string = "created_time";

    @query
    order?: OrderDirection;
}

model List<T> {
    kind: string;
    page: int32;
    size: int32;
    total: int32;
    items: T[];
}

union ConditionType {
    string,
    Available: "Available",
    Reconciled: "Reconciled",
    LastKnownReconciled: "LastKnownReconciled"
}

/**
 * Base condition fields shared by all condition types
 */
model ConditionBase {
  /**
   * Condition type
   */
  type: string;

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
   * Only updated when status changes (True/False), not when reason/message changes
   */
  @format("date-time") last_transition_time: string;
}

/**
 * Status value for adapter conditions
 */
enum AdapterConditionStatus {
    True: "True",
    False: "False",
    Unknown,
}

/**
 * Condition in Cluster/NodePool status
 * Used for semantic condition types: "ValidationSuccessful", "DNSSuccessful", "NodePoolSuccessful", etc.
 * Includes observed_generation and last_updated_time to track adapter-specific state
 */
model ResourceCondition {
  ...ConditionBase;

  status: ResourceConditionStatus;

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
   * Updated every time the adapter PUTs, even if condition status hasn't changed
   * Copied from AdapterStatus.last_report_time
   */
  @format("date-time") last_updated_time: string;
}

    const ExampleLastKnownReconciledReason: string = "AllAdaptersReconciled";
    const ExampleLastKnownReconciledMessage: string = "All required adapters report Available=True for the tracked generation";
    const ExampleReconciledReason: string = "ReconciledAll";
    const ExampleReconciledMessage: string = "All required adapters reported Available=True or Finalized=True at the current generation";
    const ExampleAdapter1: string = "adapter1";
    const ExampleAdapter2: string = "adapter2";
    const ExampleAdapter1AppliedReason: string = "Validation job applied";
    const ExampleAdapter1AppliedMessage: string = "Adapter1 validation job applied successfully";
    const ExampleAdapter1HealthReason: string = "All adapter1 operations completed successfully";
    const ExampleAdapter1HealthMessage: string = "All adapter1 runtime operations completed successfully";
    const ExampleAdapter1AvailableReason: string = "This adapter1 is available";
    const ExampleAdapter1AvailableMessage: string = "This adapter1 is available";
    const ExampleAdapter1FinalizedReason: string = "All resources deleted; cleanup confirmed";
    const ExampleAdapter1FinalizedMessage: string = "All resources deleted; cleanup confirmed";
    const ExampleAdapter2AppliedReason: string = "Validation job applied";
    const ExampleAdapter2AppliedMessage: string = "Adapter2 validation job applied successfully";
    const ExampleAdapter2HealthReason: string = "All adapter2 operations completed successfully";
    const ExampleAdapter2HealthMessage: string = "All adapter2 runtime operations completed successfully";
    const ExampleAdapter2AvailableReason: string = "This adapter2 is available";
    const ExampleAdapter2AvailableMessage: string = "This adapter2 is available";
