# Local Implementation Options

| Capability | No-cost local path | Cloud dependency | Current treatment |
|---|---|---|---|
| Identity lifecycle | Fictional JSON/CSV data plus PowerShell validation | Entra tenant for real objects | Simulated locally; cloud flow documented |
| Endpoint health | PowerShell checks for OS, disk, services, events and network | Intune for policy enforcement | Implement locally |
| Intune policies | Policy catalogue and compliance decision model | Intune licence and tenant | Documented/simulated |
| Ticketing | Versioned ticket records and SLA calculations; optional local GLPI/Zammad | None for core evidence | Implement locally first |
| Automation | PowerShell with Pester where available | Graph modules only for tenant operations | Implement locally with safe mode |
| Metrics | Timestamped test runs and generated reports | None | Implement locally |
| Diagrams | Mermaid source | None | Implement locally |

No purchase or external publication is required for the planned local path. A future tenant implementation must be explicitly authorised and separately labelled.

