`docs(ami): enrich golden image notes with a structured table and examples`

# Golden AMI Notes

Maintain a concise, auditable record of Golden AMIs built from the Phase 1 baseline.

## Table of AMIs
| Date (UTC) | AMI Name | AMI ID | Region | Source Instance | Root Snapshot | Validated | Notes |
|---|---|---|---|---|---|---|---|
| YYYY-MM-DD | eems-dev-ubuntu-nginx-vYYYYMMDD | ami-xxxxxxxx | <region> | i-xxxxxxxx | snap-xxxxxxxx | yes/no | Initial AMI after baseline |

## AMI Record Template
```markdown
## AMI Record — YYYY-MM-DD
- AMI ID: ami-xxxxxxxx
- Region: <your-region>
- Name: eems-dev-ubuntu-nginx-vYYYYMMDD
- Source instance: i-xxxxxxxx
- Snapshot(s): snap-xxxxxxxx
- Validation: launched test instance → Nginx OK, encrypted gp3 OK, IMDSv2 enforced at launch [yes/no]
- Notes: [what changed vs previous AMI]
