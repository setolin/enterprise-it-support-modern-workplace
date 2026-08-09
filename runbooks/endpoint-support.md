# Endpoint Support Runbook

## First-line triage

1. Confirm user, asset ID, location and business impact.
2. Run the local health report with user consent and collect only sanitised output.
3. Check disk space, network reachability, Defender, firewall and recent system events.
4. Compare the result with the endpoint policy catalogue.
5. Apply approved user-level remediation or link the relevant knowledge article.
6. Escalate with evidence when a privileged change, security event or hardware fault is suspected.

## Second-line escalation triggers

- Suspected malware or unauthorised access.
- BitLocker recovery or encryption failure.
- Repeated compliance failure after remediation.
- Device lost or stolen.
- Hardware fault requiring replacement.
- Multiple users affected by the same endpoint or application issue.

## Evidence handling

Do not collect passwords, tokens, personal files or full event logs by default. Prefer the smallest diagnostic output that proves the hypothesis. Redact usernames, hostnames and IP addresses before adding evidence to the repository.

