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
- `diagrams/` — Mermaid diagrams (`architecture.md`, `dataflow.md`)
- `runbooks/` — Ops procedures (`incident-status-check.md`, `backup-restore-ebs.md`)
- `configs/` — Reference configs (`instance-plan.yaml`, `dlm-policy.yaml`, `cw-alarms.json`, `tags.json`)
- `userdata/` — Bootstrap script (`web-nginx.sh`)
- `amis/` — Golden AMI notes
- `docs/` — Engineering decisions

## 🚀 Quick Start
1. Launch a small EC2 with `HttpTokens=required` (IMDSv2) and an encrypted **gp3** volume.
2. Paste `userdata/web-nginx.sh` as **User Data**.
3. Create a **DLM** policy targeting volumes tagged `Backup=dlm-daily`.
4. Configure a **System Status Check** alarm (see `configs/cw-alarms.json` as a reference).
5. Test **Hibernate**, then create a **Golden AMI**.

## 🧭 Roadmap (Phase 2)
Terraform / GitHub Actions / Ansible / enhanced monitoring and cost controls.
