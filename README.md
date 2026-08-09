# Enterprise IT Support & Modern Workplace — Applied Technical Case Study

**Project owner and accountable implementer: Alex S Beirigo — London, United Kingdom**

[LinkedIn](https://www.linkedin.com/in/alex-beirigo/) · [Authorship and verification](AUTHORSHIP.md) · [Senior audit](reports/senior-cold-audit.md) · [Interview walkthrough](interview-preparation/)

**Target roles:** IT Support Engineer · Modern Workplace Engineer · Endpoint Support Engineer · Infrastructure Support Engineer · Microsoft 365 Support Engineer

> **Ethical scope statement**
>
> Independently designed and implemented in a controlled lab environment to demonstrate enterprise identity administration, endpoint management, IT support operations, PowerShell automation and ITIL-aligned incident resolution.

This repository is a **simulated UK business environment**, not production experience. Organisations, users, devices, incidents and measurements are fictional or lab-generated unless explicitly labelled otherwise.

See [`AUTHORSHIP.md`](AUTHORSHIP.md) for the authorship boundary and verification model. The project was developed with AI-assisted drafting and validation; Alex remains responsible for understanding, executing and defending every included artefact.

## 60-second overview

Northbridge Clinical Research Ltd is a fictional London-based clinical research services company with approximately 50 users. The case study designs and progressively implements a small-business Microsoft workplace: Entra ID identity lifecycle, Windows endpoint controls, Intune-aligned management, a local ITIL ticket process, PowerShell support automation and evidence-led troubleshooting.

The project is deliberately built so that a recruiter can distinguish between:

- **Implemented locally** — executable scripts, tests, generated evidence and documented outcomes.
- **Simulated** — controlled data and ticket scenarios used to demonstrate operational thinking.
- **Designed/documented** — cloud features whose licensing or tenant access is not available in the lab.

## Recruiter evidence snapshot

| Evidence | Verified project result |
|---|---:|
| Reproducible support scenarios | 10 |
| Linked knowledge-base articles | 10 |
| Passing Pester tests | 23 |
| Authorship-labelled PowerShell scripts | 10/10 |
| Provenance manifest validation | 81/81 hashes valid |
| Secret-pattern findings in the senior audit | 0 |

The strongest evaluation path is: review the scope boundary, inspect one ticket and its linked knowledge article, run the Pester suite, then use the interview walkthrough to question Alex on design decisions and trade-offs.

## Navigation

| Area | Purpose |
|---|---|
| [`architecture/`](architecture/) | Charter, scenario, scope, decisions, risks, roadmap and diagrams |
| [`documentation/`](documentation/) | Operating model, requirements and lab limitations |
| [`powershell/`](powershell/) | Safe support and administration automation |
| [`tests/`](tests/) | Pester and validation records |
| [`tickets/`](tickets/) | Reproducible ITIL-aligned support cases |
| [`runbooks/`](runbooks/) | Repeatable support procedures |
| [`knowledge-base/`](knowledge-base/) | User-facing and engineer-facing support articles |
| [`evidence/`](evidence/) | Sanitised lab evidence and validation notes |
| [`reports/`](reports/) | Measurements and dashboards |
| [`interview-preparation/`](interview-preparation/) | Demonstration and interview material |

## Current status

Phases 1–7 provide architecture, local identity simulation, endpoint diagnostics, ten ITIL-aligned scenarios, automation, metrics and repository hardening. Senior review added authorship disclosure, linked knowledge articles, behavioural tests, integrity verification and recruitment/interview material. Entra ID and Intune execution remain documented until an authorised lab tenant and suitable licensing are available.

The latest cold assessment is in [`reports/senior-cold-audit.md`](reports/senior-cold-audit.md). It deliberately records remaining gaps instead of claiming that the project is a production implementation.

## Technology direction

Microsoft Entra ID, Microsoft 365, Microsoft Intune, Windows 11, PowerShell, Pester, Mermaid and a local/free ticketing option. The repository is publicly presented as an independently developed laboratory case study; paid tenant licensing and production deployment remain outside the implemented scope.

## Run locally

From the repository root, use Windows PowerShell 5.1 or PowerShell 7. The scripts are read-only unless a command explicitly documents a local simulation state change.

```powershell
Import-Module Pester
Invoke-Pester -Path .\tests -PassThru
.\powershell\Get-EndpointHealthReport.ps1 -ConnectivityTarget localhost
.\powershell\New-LabMetricsReport.ps1 -OutputPath .\reports\lab-metrics.json -CsvPath .\reports\lab-metrics.csv
```

Review [`documentation/implementation-status.md`](documentation/implementation-status.md) before describing any capability externally.

## What this demonstrates

Identity lifecycle design, least privilege, endpoint management, incident prioritisation, SLA thinking, troubleshooting, documentation, automation safety, evidence handling and clear communication with technical and non-technical stakeholders.
