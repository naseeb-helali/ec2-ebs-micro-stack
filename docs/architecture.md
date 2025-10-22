`docs(arch): add system architecture overview mapped to NFRs`

# System Architecture — EC2/EBS Micro Stack (Phase 1)

## Context
This repo delivers a minimal yet production-minded baseline on AWS using **EC2 + EBS** only.  
Primary non-functional goals: **Security**, **Cost control**, **Observability**.

## Components
- **EC2 Web**: single small On-Demand instance, IMDSv2 enforced (`HttpTokens=required`), Hibernate enabled if supported.
- **EBS Volume (gp3, encrypted)**: persistent storage, account default KMS.
- **CloudWatch (Basic Monitoring)**: system/instance status checks + reference alarm.
- **DLM Policy**: daily EBS snapshots with short retention during development.
- **Golden AMI**: reusable image after baseline hardening and package install.

## NFR Mapping
- **Security**: IMDSv2, no secrets in User Data, EBS encryption (KMS).
- **Cost**: small instance, limited run hours, Hibernate when idle, short snapshot retention.
- **Observability**: Basic Monitoring + system status check alarm reference.

## Diagrams
`diagrams/architecture.md` — component/deployment view.  
`diagrams/dataflow.md` — request → storage → monitoring → backups.
`diagrams/state-lifecycle.md` — EC2 lifecycle including Hibernate.

## Failure Modes (Phase 1 scope)
- **System impairment** → CloudWatch system status check triggers the runbook.
- **Volume/data issue** → restore from latest DLM snapshot.
- **Cost drift** → shutdown/hibernate policy; short snapshot retention.

## Out of Scope (Phase 1)
- VPC specifics, ALB, IAM fine-grained roles, CI/CD, IaC, detailed logging/metrics.
- Will be introduced in **Phase 2**.
