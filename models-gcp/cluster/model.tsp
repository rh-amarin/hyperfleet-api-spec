model GCPClusterSpec {
    infraID?: string;
    platform: PlatformSpec;
    release?: ReleaseSpec;
    networking?: NetworkingSpec;
    dns?: DNSSpec;
}

model PlatformSpec {
    type: "gcp";
    gcp: GCPPlatformSpec;
}

model GCPPlatformSpec {
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
