`docs(console): add Spot worker (one-time) guide with IMDSv2 and safe teardown`

# Spot Worker (One-Time) — Console Guide

This guide launches a **one-time Spot instance** as an **interruptible worker** for non-critical tasks.  
Core app remains **On-Demand**; Spot is **optional** for cost efficiency.

---

## 0) Constraints (Phase 1)
- Console-only, single instance, **no fleets**.
- **Ephemeral** workload only; no durable state kept on the instance.
- IMDSv2 enforced (`HttpTokens=required`), no secrets in User Data.

---

## 1) Launch a Spot Instance
1) **EC2 Console → Launch instance**
2) **Name and tags**
   - Name: `eems-dev-spot-worker-01`
   - Tags: `Project=ec2-ebs-micro-stack`, `Owner=naseeb.helali`, `Env=dev`, `Teardown=safe`
3) **Application and OS Images (AMI)**
   - Lightweight **Ubuntu LTS** (x86_64).
4) **Instance type**
   - Small (e.g., `t3.micro`) or any low-cost supported size.
5) **Purchasing option**
   - Check **`Request Spot instances`**
   - **Interruption behavior**: `Terminate` (simplest for ephemeral jobs)
6) **Key pair / Network**
   - Optional SSH (restrict to your IP if enabled).
   - Public subnet + public IP if you need outbound internet.
7) **Storage**
   - Root `gp3`, **Encrypted = Enabled** (account default KMS).
   - Tags on the volume: add same as above; **do not** rely on this volume for durable data.
8) **Advanced details → Metadata options**
   - Metadata: **V2 (token required)**, `HttpTokens=required`
9) **Advanced details → User Data**
   - Paste the script `userdata/spot-worker.sh`
10) **Launch instance**

---

## 2) Verify It Runs
- **Console → Instances**: watch the instance reach `running`.
- Review **System logs** or connect via SSH (optional) to ensure the user-data log is created.

---

## 3) Interruption Behavior (What to Expect)
- When capacity reclaims occur, AWS sends a **2-minute interruption notice**.
- The user data script in this repo polls the metadata endpoint and logs the event, then exits gracefully.

---

## 4) Teardown
- Terminate the Spot worker once your test completes.
- This keeps costs near-zero for Phase 1.

---

## 5) What to record
Append to `docs/decisions.md`:

```markdown
## Spot Worker (YYYY-MM-DD)
- Instance: i-xxxxxxxx
- Interruption noticed: [yes/no]
- Workload: [what the worker executed]
- Notes: [e.g., duration, termination time, any observations]
