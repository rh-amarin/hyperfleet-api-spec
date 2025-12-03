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

@defaultResponse
model Error {
    id?: string;

    /** Resource kind */
    kind?: string;

    /** Resource URI */
    href?: string;

    code?: string;
    reason?: string;
    operation_id?: string;

    /** Field-level validation errors (optional) */
    details?: {
        /** Field path that failed validation */
        field?: string;
        /** Validation error message for this field */
        error?: string;
    }[];
}

model ErrorResponse<Kind, ErrorCode> {
    kind: Kind;
    @statusCode statusCode: ErrorCode;
    @body error: Error;
}

model APIResource extends ObjectReference {
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
    @query
    search?: string;
}

model QueryParams extends SearchParams {
    @query
    page?: int32 = 1;

    @query
    pageSize?: int32 = 20;

    @query
    orderBy?: string = "created_time";

    @query
    order?: OrderDirection;
}

model List {
    kind: string;
    page: int32;
    size: int32;
    total: int32;
    items: unknown[];
}
