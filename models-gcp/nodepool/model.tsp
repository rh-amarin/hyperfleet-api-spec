model NodePoolSpecGCP {
    platform: NodePoolPlatformSpec;
    @minValue(0) nodeCount?: integer;
    autoscaling?: AutoscalingSpec;
}

model NodePoolPlatformSpec {
    type: "gcp";
    gcp: GCPNodePoolSpec;
}

model GCPNodePoolSpec {
    machineType?: string;
    @minValue(10) diskSize?: integer;
    diskType?: "pd-standard" | "pd-ssd" | "pd-balanced";
    zones?: string[];
    preemptible?: boolean;
    accelerators?: AcceleratorSpec[];
    labels?: Record<string>;
    taints?: TaintSpec[];
}
model AutoscalingSpec {
    enabled?: boolean;
    @minValue(0) minNodes?: integer;
    @minValue(1) maxNodes?: integer;
    @minValue(1) @maxValue(100) targetCPUUtilization?: integer;
    @minValue(1) @maxValue(100) targetMemoryUtilization?: integer;
    scaleDownDelay?: string;
    scaleUpDelay?: string;
}
model AcceleratorSpec {
    type: string;
    @minValue(1) count: integer;
}

model TaintSpec {
    key: string;
    value?: string;
    effect: "NoSchedule" | "PreferNoSchedule" | "NoExecute";
}
