# KB-ENDPOINT-001 — Non-compliant Windows Device

**Owner:** Alex S Beirigo  
**Status:** Local diagnostic plus simulated Intune workflow

Run `Get-EndpointHealthReport.ps1`, review supported OS, disk, Defender, firewall, connectivity and check-in evidence. Treat unavailable telemetry as `Review`, not `Pass`. Synchronise policy only through the approved management process.

Validate that mandatory controls report compliant. Escalate encryption, malware or repeated check-in failure.

