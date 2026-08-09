# Identity and Access Design

**Status:** Implemented locally as a controlled simulation; Microsoft Entra execution is documented, not claimed as completed.

## Naming standard

| Object | Convention | Example |
|---|---|---|
| User principal name | `<userid>@ncr-lab.example` | `alex.jones@ncr-lab.example` |
| Department group | `GRP-NCR-DEPT-<DEPARTMENT>` | `GRP-NCR-DEPT-DATA-ANALYTICS` |
| Function group | `GRP-NCR-FUNC-<FUNCTION>` | `GRP-NCR-FUNC-SERVICE-DESK` |
| Privileged role group | `GRP-NCR-ROLE-<ROLE>` | `GRP-NCR-ROLE-PRIVILEGED-ENGINEER` |
| Device group | `GRP-NCR-DEV-<PURPOSE>` | `GRP-NCR-DEV-WINDOWS-11` |

## Group model

- Department groups grant access to approved department workspaces.
- Function groups grant access required by a job function, such as service desk tooling.
- Privileged role groups are separate from standard user access and require approval.
- Device groups are used for policy targeting and are not a substitute for user authorisation.

## Access principles

1. Every user has one standard identity; administrative work uses a separate administrative identity.
2. Access is assigned through groups rather than individual permissions where practical.
3. Privileged access is least-privilege, time-bound where the platform supports it, and reviewed.
4. Guest access is disabled by default and requires an owner, purpose, expiry and review date.
5. Break-glass access is documented but never used for routine administration.
6. Offboarding disables sign-in, revokes sessions, removes group access and preserves data only under an approved retention process.

## Cloud implementation boundary

The local script in [`powershell/Invoke-IdentityLifecycleSimulation.ps1`](../powershell/Invoke-IdentityLifecycleSimulation.ps1) models these decisions without calling Microsoft Graph or changing a tenant. A future Entra implementation would require a separately authorised lab tenant, approved permissions and a test plan covering rollback.

