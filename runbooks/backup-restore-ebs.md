`docs(runbook): add EBS backup and restore procedure`
# Runbook — EBS Backup & Restore

## Backup
- Daily **DLM** snapshots with short retention during development.

## Restore
1. From **Snapshots**, select the latest one.
2. Create a new **Volume** from the snapshot.
3. Attach the volume to the instance (same **AZ**).
4. Validate data integrity (prefer read-only first).

## Notes
- Keep volumes small in dev to minimize snapshot costs.
