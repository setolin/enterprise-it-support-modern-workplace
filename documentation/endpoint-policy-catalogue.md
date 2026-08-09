# Endpoint Policy Catalogue

| Policy ID | Policy | Target | Baseline | Failure response |
|---|---|---|---|---|
| EP-001 | Supported Windows build | All Windows endpoints | Supported Windows 11 build | Ticket and upgrade plan |
| EP-002 | Disk encryption | All portable endpoints | BitLocker recovery process documented | Escalate to endpoint engineer |
| EP-003 | Defender health | All Windows endpoints | Antivirus and real-time protection healthy | Investigate service/signature state |
| EP-004 | Firewall | All Windows endpoints | Domain/private firewall enabled | Restore policy or escalate |
| EP-005 | Update ring | All Windows endpoints | Quality updates within defined window | Remediate and schedule restart |
| EP-006 | Local privilege | Standard users | No routine local administrator access | Approved exception only |
| EP-007 | Screen lock | All Windows endpoints | Automatic lock after inactivity | Correct configuration |
| EP-008 | Application inventory | Managed endpoints | Approved software list | Raise request or remove unauthorised software |

These are target controls. The local health script validates observable endpoint signals; it does not enforce Intune policies.

