`docs(decisions): capture security, cost and observability choices`

# Engineering Decisions — Phase 1

## Security
- Enforce IMDSv2 (`HttpTokens=required`).
- No secrets in User Data.
- EBS encrypted (account default KMS).

## Cost
- Small instance + limited run hours.
- Hibernate when idle.
- DLM snapshots with short retention.

## Observability
- Basic Monitoring only for now.
- System Status Check alarm (reference).
