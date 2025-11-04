import "@typespec/http";
using Http;

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

enum ErrorCode {
    _400: "400",
    _403: "403",
    _404: "404",
    _500: "500",
}

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

    @format("date-time") created_at: string;
    @format("date-time") updated_at: string;
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

model QueryParams {
    @query
    search?: string;

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
