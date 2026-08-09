# Endpoint Management Design

**Status:** Local endpoint checks implemented; Intune controls simulated/documented.

## Standard endpoint

- Windows 11 business edition, supported build.
- Encrypted storage using BitLocker where the device supports it.
- Microsoft Defender enabled and reporting healthy.
- Automatic updates with a controlled restart window.
- Standard user rights for day-to-day work.
- Device named using `NCR-W11-<asset-id>`.

## Management layers

| Layer | Control | Local evidence | Intune status |
|---|---|---|---|
| Inventory | OS, build, disk, services and network | `Get-EndpointHealthReport.ps1` | Documented target |
| Configuration | Firewall, Defender, lock screen and update settings | Health checks and policy catalogue | Simulated |
| Compliance | Encryption, Defender, supported OS and recent check-in | Compliance decision model | Simulated |
| Application | Approved application list and install state | Ticket/runbook workflow | Documented |
| Recovery | Lost device, non-compliance and escalation | Runbooks | Documented |

## Compliance decision

A device is **Compliant** only when all mandatory controls pass: supported OS, Defender running, firewall enabled, encrypted system volume and recent health check. A failed mandatory control creates a service ticket and may trigger access restriction in a real tenant.

## Licensing boundary

Conditional Access based on device compliance, Autopilot, Intune policy enforcement and Defender portal reporting require Microsoft cloud capabilities and licensing that are not assumed here. This repository demonstrates the operational design and local validation path, not a claimed tenant deployment.

