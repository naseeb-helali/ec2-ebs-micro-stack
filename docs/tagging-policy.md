`docs(tags): add tagging policy and enforcement guidance`

# Tagging Policy

## Purpose
Consistent tags enable cost allocation, automation (backups), and safe teardown.

## Required Keys
- `Project`: `ec2-ebs-micro-stack`
- `Owner`: `naseeb.helali`
- `Env`: `dev` *(Phase 1 only)*
- `Backup`: `dlm-daily` *(volumes eligible for DLM)*
- `Teardown`: `safe` *(filter for cleanup)`

## Recommended Keys
- `Cost`: `low`
- `Compliance`: `dev-nonprod`
- `Confidentiality`: `internal`

## Rules
1. Apply the same tags to **EC2 instance**, **EBS volume**, and **Snapshots**.
2. Keep values lowercase, hyphen-separated.
3. Do not include secrets, PII, or volatile values in tags.

## Examples
| Resource | Tags |
|---|---|
| EC2 instance | Project, Owner, Env, Teardown |
| EBS volume  | Project, Owner, Env, Backup, Teardown |
| Snapshot    | Project, Owner, Env, Backup |

## Validations (manual for Phase 1)
- Use the **Tag Editor** to confirm coverage.
- In **Cost Explorer**, enable tag-based filtering later (Phase 2).
