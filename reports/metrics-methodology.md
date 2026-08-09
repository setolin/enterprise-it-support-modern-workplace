# Metrics Methodology

## Purpose

Measure the scope and repeatability of this controlled lab without presenting lab counts as production outcomes.

## Measures

| Metric | Source | Interpretation |
|---|---|---|
| Complete support cases | `tickets/tickets.json` | Number of fictional scenarios with required fields |
| Simulated SLA compliance | `Measure-TicketSla.ps1` output | Cases within the lab target, not a service commitment |
| Automated tests | `tests/*.Tests.ps1` execution record | Tests passed in the local environment |
| PowerShell artefacts | `powershell/*.ps1` | Number of scripts available for review |
| Documentation coverage | Markdown files in project | Repository documentation volume, not quality by itself |
| Reproducible scenarios | Ticket and test datasets | Scenarios that can be rerun with fictional data |

## Rules

- Record the date, environment and tool versions.
- Do not invent before/after values where no baseline was measured.
- Do not convert file counts into productivity or hiring claims.
- Treat unavailable Windows/cloud telemetry as unavailable, not as a passing result.
- Preserve generated reports as evidence only when they contain no secrets or personal data.

