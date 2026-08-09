# Demonstration Guide — Alex S Beirigo

## Three-minute version

1. State that this is a controlled lab, not client work.
2. Show the architecture and the implemented/simulated/documented matrix.
3. Run the test suite and identify the current passing count.
4. Open one identity ticket, its KB article and the related script.
5. Close with the main limitation: no authorised Entra/Intune tenant evidence yet.

## Ten-minute version

1. Explain the fictional 50-user business and support model.
2. Walk through joiner, mover and leaver controls and least privilege.
3. Demonstrate identity `-WhatIf` and endpoint inventory fallback.
4. Trace two tickets: one routine incident and one P1 scenario.
5. Generate the lab metrics and explain why scenario times are not measured performance.
6. Show the knowledge article linkage and security boundaries.
7. Generate and verify the SHA-256 provenance manifest.
8. Explain the next implementation gate: authorised cloud tenant and signed Git history.

## Difficult questions

**Did you deploy Intune in production?**  
No. I designed the policies and implemented local diagnostic evidence. Tenant enforcement is explicitly documented as not performed.

**Are the SLA figures real?**  
They are scenario inputs used to test prioritisation and reporting. They are not observed production or lab handling durations.

**How do I know you understand the scripts?**  
Ask me to modify a threshold, introduce a test failure, explain the error path or add a new ticket-to-KB validation live.

**Why disclose AI assistance?**  
Because transparent tool use is more credible than pretending every draft was created without assistance. My responsibility is to verify, understand and defend the result.

