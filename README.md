# EC2/EBS Micro Stack — Phase 1
A secure, observable, and low-cost baseline on AWS using EC2 and EBS only.

## 🎯 Goal
Stand up a minimal EC2 web server with **IMDSv2** enforced, an **encrypted gp3** EBS volume, automated **EBS snapshots via DLM**, **CloudWatch** status checks, **Hibernate** for cost control, and a reusable **Golden AMI**.
*(Optional)* Add a Spot worker for interruptible batch tasks.

## 📦 Scope (Phase 1 only)
- One small **On-Demand** EC2 instance + **encrypted gp3** EBS.
- **Basic Monitoring** + a **System Status Check** alarm reference.
- **DLM** daily snapshots with short retention.
- **Hibernate** + **Golden AMI** creation.
- *(Optional)* **Spot** for non-critical jobs.

## ✅ Hiring Value
- Demonstrates conscious engineering decisions across **security**, **cost**, and **observability** within AWS Compute & EBS.
- Professional documentation: **Diagrams**, **Runbooks**, **Configs**, **User Data**, and a rich **README**.

## 🗂️ Repository Structure
```bash
- `diagrams/` — Mermaid diagrams (`architecture.md`, `dataflow.md`)
- `runbooks/` — Ops procedures (`incident-status-check.md`, `backup-restore-ebs.md`)
- `configs/` — Reference configs (`instance-plan.yaml`, `dlm-policy.yaml`, `cw-alarms.json`, `tags.json`)
- `userdata/` — Bootstrap script (`web-nginx.sh`)
- `amis/` — Golden AMI notes
- `docs/` — Engineering decisions
```

## 📚 Documentation Map
- Launch & Validation:  
  - EC2 Launch: `docs/console-ec2-launch.md`  
  - Post-Launch Hardening: `docs/post-launch-hardening.md`
- Operations:  
  - CloudWatch Alarm: `docs/console-cloudwatch-alarm.md`  
  - DLM Snapshots: `docs/console-dlm-snapshots.md`  
  - Hibernate Test: `docs/console-hibernate-test.md`
- Build Artifacts:  
  - Golden AMI: `docs/console-golden-ami.md`, `docs/ami-lifecycle.md`
- Governance:  
  - Architecture: `docs/architecture.md`  
  - Trade-offs: `docs/tradeoffs.md`  
  - ADRs: `docs/adr-001-imdsv2-required.md` … `docs/adr-005-spot-optional-worker.md`  
  - Threat Model: `docs/threat-model.md`  
  - Cost Model: `docs/cost-model.md`
- Runbooks & Drills:  
  - Incident: `runbooks/incident-status-check.md`  
  - Backup & Restore: `runbooks/backup-restore-ebs.md`  
  - Validation Plan: `docs/runbooks-validation.md`

## 🚀 Quick Start
1. Launch a small EC2 with `HttpTokens=required` (IMDSv2) and an encrypted **gp3** volume.
2. Paste `userdata/web-nginx.sh` as **User Data**.
3. Create a **DLM** policy targeting volumes tagged `Backup=dlm-daily`.
4. Configure a **System Status Check** alarm (see `configs/cw-alarms.json` as a reference).
5. Test **Hibernate**, then create a **Golden AMI**.

## 🧭 Roadmap (Phase 2)
Terraform / GitHub Actions / Ansible / enhanced monitoring and cost controls.
