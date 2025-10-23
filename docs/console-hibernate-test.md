`docs(console): add EC2 hibernate test guide (stop-hibernate and resume)`

# EC2 Hibernate Test (Console) — Phase 1

This guide validates **Stop – Hibernate** and **Start (Resume)** for the Phase 1 instance.

> Scope note: Hibernate support depends on the **instance type** and **AMI**. If Hibernate is not supported or was not enabled at launch, use **Stop** instead and skip this test.

---

## 0) Preconditions
- An EC2 instance from Phase 1 is **running**.
- Instance details show **Hibernate: Supported** (and **Enabled** at launch).
- Root volume is **EBS (gp3, encrypted)**.
- You can reach the instance via **HTTP** to verify app responsiveness.
- (Optional) SSH is allowed from your IP to run on-instance checks.

---

## 1) Warm-up (baseline)
- Open `http://<public-ip>` and confirm the Nginx landing page is served.
- Note the **current public IPv4** (it may change after resume if you do not use an Elastic IP).

---

## 2) Initiate Hibernate
1. **EC2 Console → Instances → Select the instance**
2. **Instance state → Stop – Hibernate**
3. Wait until the instance state transitions to **stopped** (hibernated).

> Cost note: while hibernated/stopped, **instance compute** billing pauses.  
> **EBS volumes** (and any **Elastic IP** not attached) may still incur charges.

---

## 3) Resume
1. **Instance state → Start**
2. Wait until the instance is **running** and **Status checks** are `2/2 checks passed`.
3. If you are not using an Elastic IP, confirm whether the **public IPv4** changed.

---

## 4) Post-resume Validation

**From your machine:**
```bash
# Replace with the (new) public IP if it changed
IP="X.X.X.X"
curl -I http://$IP
# Expect: HTTP/1.1 200 OK from Nginx
```

## (Optional) On-instance checks via SSH:

 `Ensure Nginx is still active after resume`
sudo systemctl status nginx --no-pager
 `Review cloud-init output for any warnings`
sudo tail -n 50 /var/log/cloud-init-output.log

#### Expected outcomes:

HTTP responds quickly with Nginx page.

No unexpected service failures after resume.



---

## 5) Troubleshooting

“Stop – Hibernate” is disabled
Hibernate may not be supported by the instance/AMI or not enabled at launch. Use Stop instead.

Public IP changed after resume
This is expected without an Elastic IP. Update your test URL or associate an EIP.

Services didn’t come back cleanly
Start with basic checks: systemctl status nginx, dmesg, cloud-init logs. If needed, do a Stop → Start cycle.

Alarm confusion during transitions
Short-lived status changes can occur. Allow a few minutes and re-check Status checks and CloudWatch alarm state.



---

## 6) What to record (in the repo)

#### Append to docs/decisions.md:

## Hibernate Test (YYYY-MM-DD)
- Supported: [yes/no]
- Enabled-at-launch: [yes/no]
- Resume time (approx): [N seconds]
- Public IP changed after resume: [yes/no]
- App response after resume: [OK/Issues]
- Notes: [any deviations or follow-ups]


---

## 7) Clean-up / Next Steps

If this is a dev environment, keep the instance hibernated or stopped when idle.

Proceed to Golden AMI creation in Phase 1 Step 9.
