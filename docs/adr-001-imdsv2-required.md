`docs(adr): IMDSv2 is required`

# ADR-001: Enforce IMDSv2

- **Status:** Accepted
- **Context:** Protect instance metadata and any temporary credentials from unauthenticated access.
- **Decision:** Set `HttpTokens=required` on the instance.
- **Consequences:** Any on-instance calls must use IMDSv2 session tokens; legacy scripts need updates.
