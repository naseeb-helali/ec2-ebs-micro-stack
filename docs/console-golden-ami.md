`docs(console): add Golden AMI creation, validation and cleanup guide`

# Golden AMI (Console Guide) — Phase 1

Create a reusable **Golden AMI** from the Phase 1 instance once baseline hardening is done (Nginx ok, IMDSv2 enforced, encrypted gp3).

> Scope: console-only, single-Region. Copy/sharing options are noted for future phases.

---

## 0) Preconditions
- The instance is **Running** and in a good state (2/2 checks).
- Baseline is applied (Nginx installed via User Data; no secrets on disk).
- Root volume: **gp3, encrypted** (account default KMS).
- Optional: stop/hibernate first to minimize file changes during imaging.

---

## 1) Create Image (AMI)
1. **EC2 → Instances → select the instance**
2. **Actions → Image and templates → Create image**
3. Fill the form:
   - **Image name**: `eems-dev-ubuntu-nginx-vYYYYMMDD`
   - **Image description**: `Golden AMI for EC2/EBS Micro Stack (Phase 1).`
   - **No reboot**: leave **unchecked** for consistency *(recommended)*  
     > If downtime is acceptable, allow reboot to quiesce the filesystem.
   - **Instance volumes**: keep root **gp3 (encrypted)** as-is
   - **Tags**: add at least
     - `Project=ec2-ebs-micro-stack`
     - `Owner=naseeb.helali`
     - `Env=dev`
4. Click **Create image**.

Result:
- An **AMI** appears under **AMIs** (State: `pending` → `available`).
- A **Snapshot** is created for the root volume (visible under **Snapshots**).

---

## 2) Validate the AMI
1. **Launch instance** from the new AMI (tiny size, public IP for quick test).
2. Apply tags on the instance and root volume as per `docs/tagging-policy.md`.
3. Verify:
   - HTTP serves the Nginx landing page.
   - IMDSv2 can still be enforced at launch (`HttpTokens=required`).
   - Root volume remains **encrypted**.

Record the result in the repo (see section 4).

---

## 3) Cost & Hygiene Notes
- AMIs **do not** incur charges; **Snapshots do** (storage-based). Keep volumes small in dev.
- Delete stale AMIs **and** their underlying snapshots when no longer needed.
- Without an Elastic IP, the **public IP** of test instances may change between launches.

---

## 4) What to record (append to the repo)

Append to `amis/golden-image-notes.md`:

```markdown
## AMI Record — YYYY-MM-DD
- AMI ID: ami-xxxxxxxx
- Region: <your-region>
- Name: eems-dev-ubuntu-nginx-vYYYYMMDD
- Source instance: i-xxxxxxxx
- Snapshot(s): snap-xxxxxxxx
- Validation: launched test instance → Nginx OK, encrypted gp3 OK, IMDSv2 enforced at launch [yes/no]
- Notes: [changes since previous AMI, e.g., config updates]
```

#### And add to docs/decisions.md:

## Golden AMI (YYYY-MM-DD)
- Created: eems-dev-ubuntu-nginx-vYYYYMMDD (ami-xxxxxxxx)
- Rationale: faster repeatable launches; stable baseline
- Next: consider cross-Region copy or account sharing in later phases


---

## 5) Optional — Sharing/Copy (For later phases)

Copy AMI to another Region (AMIs are Region-scoped).

Share AMI privately with specific AWS accounts.

Avoid Public sharing for security and licensing reasons in dev.



---

## 6) Cleanup (optional)

Terminate the test instance created from the AMI.

Keep the AMI; remove older, obsolete AMIs/snapshots if no longer needed.
