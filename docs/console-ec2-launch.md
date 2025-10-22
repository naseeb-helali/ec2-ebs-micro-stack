`docs(console): add precise EC2 launch guide with IMDSv2, encrypted gp3, tags and User Data`

# EC2 Launch Guide (Console) — Phase 1

This guide launches a **small, secure, observable, low-cost** EC2 instance with:
- **IMDSv2 enforced** (`HttpTokens=required`)
- **Encrypted gp3** EBS root volume
- **Unified tags** (cost/ops/backup)
- **Minimal Security Group** for HTTP (and optional SSH)
- **User Data** that bootstraps Nginx (no secrets)

> Phase 1 is console-only and keeps costs minimal.

---

## 0) Pre-flight Checklist
- **Region** selected (keep consistent throughout Phase 1).
- **Key pair** available (optional if you won’t SSH).
- **Tags** ready (see `configs/tags.json` and `docs/tagging-policy.md`).
- **User Data** script path: `userdata/web-nginx.sh` (no secrets).
- You accept a public IP for testing HTTP, or you will test via a bastion.

---

## 1) Launch Instance (Wizard)
1. **EC2 Console → Launch instance**
2. **Name and tags**
   - Name: `eems-dev-web-01`
   - Instance **Tags**:
     - `Project=ec2-ebs-micro-stack`
     - `Owner=naseeb.helali`
     - `Env=dev`
     - `Teardown=safe`
3. **Application and OS Images (AMI)**
   - Choose a lightweight **Ubuntu LTS** AMI (x86_64).
4. **Instance type**
   - Small burstable (e.g., `t3.micro`). If unavailable, use a comparable free/low-cost size.
5. **Key pair (login)** (optional)
   - Create/select if you plan to SSH.
6. **Network settings**
   - VPC: default (Phase 1).
   - Subnet: any public subnet.
   - **Auto-assign public IP: Enabled** (for quick HTTP test).
   - **Security Group**:
     - Rule 1: **HTTP** TCP 80 → Source `0.0.0.0/0` (demo only).
     - Rule 2 (optional): **SSH** TCP 22 → Source limited to your IP.
7. **Configure storage**
   - **Root volume**: `gp3`, **Size**: `8 GiB`, **Encrypted**: enabled (account default KMS).
   - **Add volume tags** (click Add tag for the volume):
     - `Project=ec2-ebs-micro-stack`
     - `Owner=naseeb.helali`
     - `Env=dev`
     - `Backup=dlm-daily`
     - `Teardown=safe`
8. **Advanced details → Metadata options**
   - **Metadata version**: `V2 (token required)`
   - **HttpTokens**: `required`
   - **HttpEndpoint**: `enabled`
9. **Advanced details → User data**
   - Paste the content of `userdata/web-nginx.sh` (no secrets).
10. **Review and Launch**
    - Confirm all settings and click **Launch instance**.

---

## 2) Post-launch Verification

### A) Check instance reachability
- From the **Instances** list, copy the **Public IPv4 address**.
- Visit `http://<public-ip>` — expect the Nginx welcome page from the User Data script.

### B) Verify IMDSv2 enforcement (on-instance)
If you enabled SSH and can connect:
```bash
# Without token (should fail with 401/403 or timeout)
curl -i http://169.254.169.254/latest/meta-data/

# With token (should succeed)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/
```

## C) Verify EBS encryption and tags (Console)

### Volumes → select root volume:

Encrypted: should show Yes with your account default KMS key.

Tags: confirm Project/Owner/Env/Backup/Teardown exist.



## D) Verify Security Group

Confirm inbound HTTP 80 from the sources you intend, and restrict SSH if enabled.



---

## 3) Notes and Safety

Keep User Data free of secrets; environment variables containing credentials are not allowed.

For dev cost control:

Limit instance run hours.

Use Hibernate when idle (if supported by AMI/type).


Snapshots will be added by DLM in a later step.



---

## 4) What to record (for the repo)

Instance ID, public IP (if any), launch date/time, AMI ID used.

Any deviations from configs/instance-plan.yaml.

Update docs/decisions.md if you changed defaults for a justified reason.

