`docs(console): add CloudWatch System Status Check alarm guide with safe test and SNS option`

# CloudWatch Alarm — EC2 System Status Check (Console)

This guide creates a **low-cost** CloudWatch alarm for **System Status Check** using **Basic Monitoring** (no extra charges).  
Optionally, you can wire an **SNS email** notification and perform a **safe test** without breaking the instance.

---

## 0) Pre-requisites
- An EC2 instance from Phase 1 is **running** in your chosen Region.
- Basic Monitoring is sufficient (do **not** enable Detailed Monitoring in Phase 1).
- (Optional) An email address you control for SNS.

---

## 1) Create the Alarm (System Status Check)
1. **CloudWatch Console → Alarms → Create alarm**
2. **Select metric** → `EC2` → `Per-Instance Metrics` → choose your **InstanceId** → select **StatusCheckFailed_System**.
3. **Conditions**
   - **Statistic**: `Maximum`
   - **Period**: `5 minutes` (Basic Monitoring granularity)
   - **Threshold type**: `Static`
   - **Whenever StatusCheckFailed_System is** `Greater than or equal to` **1**
   - **Additional configuration**: **Treat missing data as `not breaching`**
4. **Notification (Actions)**
   - *Option A (no notifications)*: uncheck/disable actions (fine for Phase 1).
   - *Option B (recommended)*: **Create SNS topic** → name e.g., `eems-dev-alarms` → email subscription (confirm via email).
5. **Name and description**
   - **Alarm name**: `eems-dev-system-status-check`
   - **Description**: `Triggers when EC2 system status check fails (Phase 1, Basic Monitoring).`
6. **Create alarm**.

---

## 2) Safe Test (without breaking anything)
Since system failures are hard to simulate safely, create a **temporary test alarm** on CPU to validate SNS/email delivery:

1. **Alarms → Create alarm → Select metric** → `EC2` → `Per-Instance Metrics` → **CPUUtilization** for the same InstanceId.
2. **Conditions**
   - **Statistic**: `Average`
   - **Period**: `5 minutes`
   - **Threshold**: set `Lower` than **1%** with **Less than** comparison (or use `Static > 0.1%` and generate a quick load).
3. **Actions**: reuse the same **SNS topic** (if configured).
4. **Name**: `eems-dev-cpu-test`
5. **Create alarm**, then:
   - Either **generate CPU**: `sudo apt-get install -y stress-ng && stress-ng -c 1 -t 60s`  
     *(if you allowed SSH; otherwise just wait or adjust threshold)*
   - Or set a threshold that immediately **ALARM**s due to idle.
6. Confirm you receive the **SNS email** (if configured).
7. **Delete** the **CPU test alarm** after validation.

> Keep the real **System Status Check alarm** active.

---

## 3) Verification Checklist
- [ ] Alarm `eems-dev-system-status-check` shows **OK** state initially.
- [ ] **Treat missing data** is set to **not breaching**.
- [ ] (If Actions enabled) SNS topic exists and email is **confirmed**.
- [ ] (Optional) Temporary CPU test alarm fired and was removed afterward.

---

## 4) Troubleshooting
- Alarm stuck in `INSUFFICIENT_DATA`? Wait for at least one metric period (5 minutes) or verify the instance is running.
- No emails? Confirm the **SNS subscription** by clicking the email confirmation link.
- Avoid Detailed Monitoring in Phase 1 to keep costs minimal.

---

## 5) What to record in the repo
Append to `docs/decisions.md`:

```markdown
## CloudWatch Alarm (YYYY-MM-DD)
- System status alarm: eems-dev-system-status-check
- Metric: StatusCheckFailed_System (Maximum, 5m)
- Missing data: not breaching
- Actions: [none|SNS: eems-dev-alarms, email: you@example.com]
- Test: temporary CPU alarm used → OK → removed
