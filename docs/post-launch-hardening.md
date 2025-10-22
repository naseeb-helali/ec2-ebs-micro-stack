`docs(hardening): add post-launch validation and hardening checklist`

# Post-Launch Validation & Hardening (Phase 1)

This guide validates the new EC2 instance and applies minimal hardening **within Phase 1 scope**.

> Scope note: Phase 1 uses **console-only** operations and focuses on EC2/EBS, IMDSv2, basic monitoring, and backups via DLM. Deeper OS/IAM hardening is deferred to Phase 2.

---

## 1) Validation Checklist

- [ ] **Nginx** serves the default page from User Data.
- [ ] **IMDSv2** is enforced (`HttpTokens=required`).
- [ ] **EBS root volume** is **encrypted** (account-default KMS).
- [ ] **Tags** exist on **instance** and **volume** (and will propagate to snapshots).
- [ ] **Security Group** allows **HTTP :80** (demo) and **SSH :22** only from a trusted source (optional).

---

## 2) Nginx Health Check

**From your machine:**
```bash
# Replace with your public IPv4 of the instance
IP="X.X.X.X"
curl -I http://$IP
# Expect: HTTP/1.1 200 OK (or a valid Nginx response)
```

#### If you can SSH (optional):

sudo systemctl status nginx --no-pager
sudo tail -n 50 /var/log/nginx/access.log
sudo tail -n 50 /var/log/nginx/error.log

#### Troubleshooting:

Ensure the instance has a public IP or reachable path.

Verify the Security Group inbound rule for TCP 80.

Confirm User Data executed (see /var/log/cloud-init-output.log).



---

## 3) IMDSv2 Enforcement Test (On-Instance)

> Requires SSH access. Skip if SSH is intentionally disabled.


` 1) Without a token (should fail)`
curl -i http://169.254.169.254/latest/meta-data/

` 2) With a token (should succeed)`
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/

#### Expected:

The first call fails (401/403/timeout).

The token-based call succeeds.



---

## 4) EBS Encryption & Tags (Console)

Volumes → Select the root volume:

Encrypted: Yes (account default KMS).

Tags present: Project, Owner, Env, Backup, Teardown.


Instances → Select the instance:

Tags present: Project, Owner, Env, Teardown.




---

## 5) Security Group Baseline (Console)

#### Inbound:

HTTP (TCP/80) → 0.0.0.0/0 (demo scope only).

SSH (TCP/22) → Your IP only (or omit SSH entirely if not needed).


#### Outbound:

Default allow (for updates, package installs).


#### Notes:

Tighten HTTP sources if you require stricter access in dev.

OS firewalls (e.g., ufw) are optional in Phase 1; rely on Security Groups.



---

## 6) Hibernate Capability (Optional Check)

In Instance details confirm Hibernate is supported (varies by type/AMI).

If supported:

Instance state → Stop - Hibernate, then Start to confirm fast resume.




---

## 7) What to Record

Update docs/decisions.md with:

Instance ID, AMI ID, public IP (if any), launch time.

Validation outcomes (Nginx OK, IMDSv2 enforced, EBS encrypted, tags verified).

Any deviations from configs/instance-plan.yaml and why.


Example snippet to append:

## Validation (YYYY-MM-DD)
- Instance: i-xxxxxxxx (AMI: ami-xxxxxxxx, IP: X.X.X.X)
- Nginx: OK
- IMDSv2: enforced (token test passed)
- EBS: encrypted (KMS default)
- Tags: present (instance/volume)
- SG: HTTP :80 open (demo), SSH restricted (or disabled)
- Notes: hibernate support [yes/no], resumed OK [yes/no]
