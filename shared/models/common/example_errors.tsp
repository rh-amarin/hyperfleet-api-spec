const ExampleError400 = #{
    type: "https://api.hyperfleet.io/errors/validation-error",
    title: "Validation Failed",
    status: 400,
    detail: "The cluster name field is required",
    instance: "/api/hyperfleet/v1/clusters",
    code: "HYPERFLEET-VAL-001",
    timestamp: "2024-01-15T10:30:00Z",
    trace_id: "aabbccddeeff0011"
};

const ExampleError401 = #{
    type: "https://api.hyperfleet.io/errors/authentication-required",
    title: "Authentication Required",
    status: 401,
    detail: "Account authentication could not be verified",
    instance: "/api/hyperfleet/v1/clusters",
    code: "HYPERFLEET-AUT-001",
    timestamp: "2024-01-15T10:30:00Z",
    trace_id: "1122334455667788"
};

const ExampleError403 = #{
    type: "https://api.hyperfleet.io/errors/permission-denied",
    title: "Permission Denied",
    status: 403,
    detail: "You do not have permission to perform this action",
    instance: "/api/hyperfleet/v1/clusters",
    code: "HYPERFLEET-AUZ-001",
    timestamp: "2024-01-15T10:30:00Z",
    trace_id: "99aabbcc11223344"
};

const ExampleError404 = #{
    type: "https://api.hyperfleet.io/errors/resource-not-found",
    title: "Resource Not Found",
    status: 404,
    detail: "Cluster with id='019466a0-8f8e-7abc-9def-0123456789ab' not found",
    instance: "/api/hyperfleet/v1/clusters/019466a0-8f8e-7abc-9def-0123456789ab",
    code: "HYPERFLEET-NTF-001",
    timestamp: "2024-01-15T10:30:00Z",
    trace_id: "deadbeef12345678"
};

const ExampleError409 = #{
    type: "https://api.hyperfleet.io/errors/resource-conflict",
    title: "Resource Conflict",
    status: 409,
    detail: "This Cluster already exists",
    instance: "/api/hyperfleet/v1/clusters",
    code: "HYPERFLEET-CNF-001",
    timestamp: "2024-01-15T10:30:00Z",
    trace_id: "cafe0011aabb9988"
};

const ExampleError500 = #{
    type: "https://api.hyperfleet.io/errors/internal-error",
    title: "Internal Server Error",
    status: 500,
    detail: "Unspecified error",
    instance: "/api/hyperfleet/v1/clusters",
    code: "HYPERFLEET-INT-001",
    timestamp: "2024-01-15T10:30:00Z",
    trace_id: "f0f0f0f0a1a1a1a1"
};
