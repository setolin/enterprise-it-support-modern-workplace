# Automation Standards

Every support script in this repository must:

- use comment-based help with synopsis, description, parameters and examples;
- validate input and fail with a useful error;
- default to read-only behaviour or explicit simulation mode;
- avoid passwords, tokens, secrets and full user file contents;
- return structured objects suitable for CSV/JSON reporting;
- use UTC timestamps for evidence;
- document prerequisites and limitations;
- include a test or static safety check;
- explain rollback where the script can change state.

The current local scripts meet these standards to the extent documented in their help blocks. Cloud lifecycle operations remain outside their scope.

