import "@typespec/http";
using Http;


alias Identifier = string;

alias KindCluster = "Cluster";
alias KindStatus = "Status";
alias KindNodePool = "NodePool";

model ID {
    /** Resource identifier */
    @format("uuid") id: Identifier;
}
model APIResourceReference<Kind> {
    ...ID;

    /** Resource kind */
    kind: Kind;

    /** Resource URI */
    href: string;
}
model APIResource<Kind> {
    ...APIResourceReference<Kind>;

    /** labels for the API resource as pairs of name:value strings */
    labels: Record<string>;
}

model PageDataRequest {
    page?: integer = 1;
    size?: integer = 20;
}

model PageData {
    page: integer;
    size: integer;
    total: integer;
}

model Page<Kind> {
    page: integer;
    size: integer;
    total: integer;
    items: Kind[];
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
}
