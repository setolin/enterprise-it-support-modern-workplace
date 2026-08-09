# Risk Register

| ID | Risk | Likelihood | Impact | Treatment | Owner |
|---|---|---:|---:|---|---|
| R-001 | Cloud feature cannot be executed without suitable tenant/licence | Medium | High | Label as documented; provide local simulation and validation plan | Alex |
| R-002 | Accidental exposure of credentials or personal data | Low | High | Fictional data, secret-focused ignore rules, security review before delivery | Alex |
| R-003 | Simulated ticket metrics are mistaken for production results | Medium | High | Label every metric as lab-generated and document methodology | Alex |
| R-004 | Scripts make unintended changes | Low | High | Parameter validation, confirmation, simulation mode, logging and rollback notes | Alex |
| R-005 | Repository becomes too broad to explain in interview | Medium | Medium | Maintain a three-minute narrative and traceability matrix | Alex |
| R-006 | Local ticketing platform adds setup overhead | Medium | Medium | Keep platform-independent ticket records; add runtime only if beneficial | Alex |
| R-007 | Architecture uses permissions beyond least privilege | Low | High | Separate admin identities, role matrix and access review procedure | Alex |

