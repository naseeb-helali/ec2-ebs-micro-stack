`docs(reports): add sample report for backup drill`

# Sample Report — Backup Drill (Restore from Snapshot)

**Date (UTC):** YYYY-MM-DD  
**Snapshot:** snap-xxxxxxxx (from policy daily-dev-backups)  
**Temp Volume:** vol-xxxxxxxx (same AZ as instance)

## Actions
- Created volume from snapshot ✔
- Attached to instance ✔
- Read-only mount and data inspection ✔
- Detached and deleted temp volume ✔

## Evidence
- Volume creation/attachment IDs recorded.

## Notes
- Data structure intact; no errors observed.
