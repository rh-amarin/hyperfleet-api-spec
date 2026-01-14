import "@typespec/http";
import "@typespec/openapi";
using Http;
using OpenAPI;

alias Identifier = string;

alias KindCluster = "Cluster";
alias KindClusterStatus = "ClusterStatus";
alias KindNodePoolStatus = "NodePoolStatus";
alias KindNodePool = "NodePool";

/**
 * Phase of a resource (Cluster or NodePool)
 */
enum ResourcePhase {
    NotReady,
    Ready,
    Failed,
}

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
 * Validation constraint types for field-level errors
 */
enum ValidationConstraint {
    required: "required",
    min: "min",
    max: "max",
    min_length: "min_length",
    max_length: "max_length",
    pattern_match: "pattern",
    enum_value: "enum",
    format_check: "format",
    unique: "unique",
}

/**
 * Field-level validation error detail (RFC 9457 extension)
 */
model ValidationError {
    /** JSON path to the field that failed validation */
    @example("spec.name")
    field: string;

    /** The invalid value that was provided (if safe to include) */
    value?: unknown;

    /** The validation constraint that was violated */
    constraint?: ValidationConstraint;

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
    status: int32;

    /** Human-readable explanation specific to this occurrence */
    @example("The cluster name field is required")
    detail?: string;

    /** URI reference for this specific occurrence */
    @format("uri")
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
model APICreatedResource {
    @format("date-time") created_time: string;
    @format("date-time") updated_time: string;
    @format("email") created_by: string;
    @format("email") updated_by: string;
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
     * Examples: `status.phase='NotReady'`, `name in ('c1','c2')`, `labels.region='us-east'` */
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
