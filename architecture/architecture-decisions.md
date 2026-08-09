# Architecture Decision Records

## ADR-001 — Use a fictional UK organisation

**Status:** Accepted

**Decision:** Model Northbridge Clinical Research Ltd with approximately 50 users.

**Reason:** It is large enough to demonstrate departments, access boundaries, support queues and prioritisation, while remaining understandable and reproducible.

**Alternatives:** A personal lab would be too narrow; a large enterprise would require unsupported complexity and data.

## ADR-002 — Separate cloud design from local execution

**Status:** Accepted

**Decision:** Clearly label Entra ID, Intune and Microsoft 365 capabilities as implemented, simulated or documented.

**Reason:** The project must remain credible when licensing, tenant access or API permissions are unavailable.

## ADR-003 — Prefer PowerShell with simulation mode

**Status:** Accepted

**Decision:** Administrative scripts default to non-destructive validation or `-WhatIf`-style simulation where applicable.

**Reason:** This makes testing possible without a production tenant and reduces accidental changes.

## ADR-004 — Use a local/free ticketing implementation path

**Status:** Accepted

**Decision:** Model the ticket workflow in repository data first, then evaluate a local GLPI or Zammad deployment if runtime resources permit.

**Reason:** The case study must remain usable without a paid SaaS account. A repository-first model also provides transparent evidence and version control.

