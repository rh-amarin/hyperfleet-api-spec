import "@typespec/http";
import "@typespec/openapi";
using Http;
using OpenAPI;

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
    @format("date-time") created_at: string;
    @format("date-time") updated_at: string;
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
    orderBy?: string = "created_at";

    @query
    order?: OrderDirection = OrderDirection.desc;
}

model List {
    kind: string;
    page: int32;
    size: int32;
    total: int32;
    items: unknown[];
}
