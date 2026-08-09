# Joiner, Mover and Leaver Runbook

## Joiner — onboarding

1. Confirm approved request, start date, manager, department and access profile.
2. Validate that the user ID is unique and the data contains no secret.
3. Create or simulate the standard identity.
4. Add only the department and function groups required by the access matrix.
5. Assign a device and application checklist.
6. Require MFA registration through the approved identity process.
7. Validate sign-in, group membership, device compliance and user communication.
8. Record evidence and close the request only after user confirmation.

## Mover — internal transfer

1. Obtain the approved change and new manager details.
2. Compare current and target access profiles.
3. Remove obsolete department/function access before adding new access where risk warrants it.
4. Revalidate application and data access with the new manager.
5. Record the before/after group membership and notify the user.

## Leaver — offboarding

1. Confirm the approved leaving date and urgency.
2. Disable sign-in; do not delete evidence before retention decisions are made.
3. Revoke active sessions and remove group assignments.
4. Recover or block the assigned device and preserve business data under policy.
5. Transfer ownership of approved resources.
6. Notify the manager and service desk, then record completion evidence.

## Rollback

For a joiner or mover, restore the prior simulated state from the run log. For a leaver, re-enablement requires a new approved request and must not be performed merely by rerunning the script.

