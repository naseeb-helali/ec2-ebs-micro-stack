`docs(console): add DLM daily snapshot policy guide with verification`

# DLM — Daily EBS Snapshots (Console Guide)

This guide creates a **daily** EBS **snapshot policy** using **Data Lifecycle Manager (DLM)**.  
Target volumes are identified by the tag `Backup=dlm-daily`. Retention is **3 days** for low dev cost.

---

## 0) Pre-requisites
- An EC2 instance is running with a **root gp3 encrypted volume**.
- The **volume** has tags from Phase 1, including: `Backup=dlm-daily`.
- Region is consistent with your instance/volume.

---

## 1) Create the DLM Policy
1. **EC2 Console → Elastic Block Store → Lifecycle Manager (DLM) → Create lifecycle policy**
2. **Policy type**: `EBS snapshot policy`
3. **Target resources**:
   - Resource type: `Volume`
   - **Target tags**: `Backup=dlm-daily`
   - (Enable) **Copy tags from source** (recommended)
4. **Schedule**
   - Schedule name: `daily-dev-backups`
   - Frequency: `Every 1 day`
   - Start time: pick a suitable UTC time (e.g., `00:30 UTC`)
   - **Retention**: keep **3** snapshots
5. **IAM role**: accept/create the default DLM role if prompted
6. **Policy state**: `Enabled`
7. **Create policy**

> Notes  
> - First automated snapshot is created at/after the scheduled time.  
> - Use a **short retention** in dev to keep costs minimal.

---

## 2) Verification
- After the first schedule executes:
  - **Snapshots** → filter by tag `Project=ec2-ebs-micro-stack` or `Backup=dlm-daily`
  - Confirm snapshots belong to the intended volume and **inherit tags**.
- If you want an earlier functional check:
  - Manually create a one-off snapshot of the same volume and ensure tags exist; DLM will manage only snapshots it created per policy.

---

## 3) Cleanup / Adjustments
- To pause: set policy state to **Disabled**.
- To change retention or time window: edit the policy schedule.
- To exclude a volume: remove `Backup=dlm-daily` from that volume.

---

## 4) What to record (for the repo)
Append to `docs/decisions.md`:

```markdown
## DLM Policy (YYYY-MM-DD)
- Policy: daily-dev-backups (enabled)
- Target: Volumes tagged Backup=dlm-daily
- Retention: 3 snapshots
- Start time (UTC): 00:30
- CopyTagsFromSource: true
- Verification: snapshot created on YYYY-MM-DD, tags inherited [yes/no]
