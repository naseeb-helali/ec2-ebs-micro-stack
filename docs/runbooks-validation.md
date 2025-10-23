`docs(runbooks): add validation plan for incident and backup drills`

# Runbooks Validation — Phase 1

This document validates two operational runbooks with **safe**, low-cost drills.

> Scope: console-first, no forced system failures.  
> Goal: ensure the team can execute procedures reliably and record outcomes.

---

## Drill A — Incident: System Status Check (Tabletop + Light Reboot)

### Objective
Validate the incident response flow (**without** inducing a real system impairment).

### Preconditions
- An EC2 instance from Phase 1 is **running**.
- CloudWatch **System Status Check** alarm exists (Phase 1 Step 6).
- Optional SSH for on-instance verification.

### Steps (Tabletop)
1. Open `runbooks/incident-status-check.md` and walk through the steps verbally.
2. Review the alarm configuration in `CloudWatch → Alarms` (treat missing data = not breaching).
3. Confirm current **Status checks = 2/2** in the EC2 console.
4. (Light, optional) **Reboot** the instance to practice checking alarm/health transitions.
5. Verify the instance returns to **2/2 checks passed** within a few minutes.

### Success Criteria
- Team knows exactly **where to look** (EC2 status checks, alarm state).
- Can perform **Reboot → Re-validate** safely.
- Can document findings in `docs/decisions.md`.

### Record (append to decisions)
```markdown
## Incident Drill (YYYY-MM-DD)
- Instance: i-xxxxxxxx
- Alarm check: config OK (notBreaching)
- Action: [tabletop only | reboot + verify]
- Outcome: 2/2 checks passed after [N] minutes
- Notes: [observations]
```

---

## Drill B — Backup & Restore from Snapshot (Hands-on)

### Objective

Prove that data can be recovered from the latest DLM snapshot without affecting the running instance.

### Preconditions

DLM policy is enabled; at least one snapshot exists (Backup=dlm-daily).

You know the AZ of the running instance.


### Steps (Console)

1. Snapshots → select the latest DLM-created snapshot.


2. Actions → Create volume from snapshot in the same AZ as the instance.


3. Attach the new volume to the instance (read-only usage recommended).


4. (Optional SSH) lsblk to identify the device; mount read-only and inspect files; unmount.


5. Detach and Delete the temporary volume to avoid costs.



### Success Criteria

Volume created and attached successfully.

Data inspected/read without errors.

Cleanup done (detached & deleted).


### Record (append to decisions)
```
## Backup Drill (YYYY-MM-DD)
- Snapshot: snap-xxxxxxxx
- Temp volume: vol-xxxxxxxx (same AZ)
- Validation: data accessible [yes/no]
- Cleanup: detached & deleted [yes/no]
- Notes: [observations]
```

---

## Metrics & Evidence

Time to validate status checks after reboot: ≤ 10 minutes.

Time to create/attach/inspect/cleanup a restore volume: ≤ 20 minutes.

Screenshots or IDs (instance/volume/snapshot) recorded in reports.



---

## Follow-ups

If drills reveal gaps, update the corresponding runbook:

runbooks/incident-status-check.md

runbooks/backup-restore-ebs.md


Capture changes as docs(decisions): update runbooks after drill findings.
