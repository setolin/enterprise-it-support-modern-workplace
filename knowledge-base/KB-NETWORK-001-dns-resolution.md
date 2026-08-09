# KB-NETWORK-001 — DNS Resolution Failure

**Owner:** Alex S Beirigo  
**Status:** Local diagnostic procedure

Compare public and target-name resolution with `Resolve-DnsName`; test TCP reachability separately. Record configured resolvers without exposing unrelated network data. Flush the local resolver cache only after evidence indicates a stale cache.

Validate resolution and application access. Escalate missing records, multiple affected users or authoritative DNS faults.

