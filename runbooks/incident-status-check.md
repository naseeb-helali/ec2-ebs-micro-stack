`docs(runbook): add system status check incident procedure`

# Runbook — EC2 System Status Check Failure

## Symptoms
- CloudWatch alarm: `StatusCheckFailed_System = 1`

## Actions
1. Open EC2 console → **Status Checks**.
2. If it's a system-level issue: try **Reboot**.
3. If it persists: **Stop (Hibernate if supported) → Start**.
4. Validate EBS attachment and health.
5. If data is impacted: restore from the latest **DLM** snapshot.

## Notes
- Do **not** change User Data during incident handling.
- Document findings in `docs/decisions.md`.
