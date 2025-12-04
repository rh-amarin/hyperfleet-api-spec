model ClusterSpec {
    infraID?: string;
    platform: ClusterPlatformSpec;
    release?: ReleaseSpec;
    networking?: NetworkingSpec;
    dns?: DNSSpec;
}

model ClusterPlatformSpec {
    type: "gcp";
    gcp: ClusterPlatform;
}

model ClusterPlatform {
    projectID?: string;
    region?: string;
    zone?: string;
    network?: string;
    subnet?: string;
}

model ReleaseSpec {
    image?: string;
    version?: string;
}

model NetworkingSpec {
    clusterNetwork?: ClusterNetworkEntry[];
    serviceNetwork?: string[];
}

model ClusterNetworkEntry {
    cidr?: string;
    hostPrefix?: integer;
}

model DNSSpec {
    baseDomain?: string;
}
