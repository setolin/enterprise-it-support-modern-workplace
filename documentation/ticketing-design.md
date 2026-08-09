# Local Ticketing and ITIL Design

**Status:** Implemented as a repository-first local model. No external ticketing service is required.

## Ticket types

| Type | Meaning |
|---|---|
| Incident | Unplanned interruption or degradation of a service |
| Service Request | Standard user request fulfilled through an approved process |
| Problem | Investigation of an underlying or recurring cause |
| Change | Controlled modification with approval, implementation and rollback |

## Impact and urgency matrix

| Impact \ Urgency | Low | Medium | High |
|---|---:|---:|---:|
| Low | P4 | P4 | P3 |
| Medium | P4 | P3 | P2 |
| High | P3 | P2 | P1 |

## Simulated SLA targets

| Priority | First response | Target resolution |
|---|---:|---:|
| P1 Critical | 15 minutes | 4 hours |
| P2 High | 30 minutes | 8 hours |
| P3 Medium | 4 business hours | 2 business days |
| P4 Low | 1 business day | 5 business days |

These are lab targets for testing workflow logic. They are not commercial commitments.

The `scenarioElapsedMinutes` values in `tickets.json` are deliberately assigned scenario inputs used to test priority and SLA calculations. They are not observed handling times and must never be presented as measured performance. Real timing evidence requires timestamped execution records.

## Queues and escalation

- `Service Desk L1`: triage, user communication and standard fixes.
- `Endpoint L2`: Windows, applications, compliance and devices.
- `Identity L2`: access, MFA, lifecycle and groups.
- `Infrastructure L2`: DNS, VPN and shared services.
- `Security/Incident`: suspected compromise, lost devices and critical events.

P1 and suspected security incidents escalate immediately to the Systems Engineer and Operations Director. Every escalation includes impact, timeline, evidence, actions taken and the next decision required.
