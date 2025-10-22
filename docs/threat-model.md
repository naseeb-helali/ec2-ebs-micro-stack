`docs(sec): add lightweight threat model`

# Threat Model (Lightweight)

## Attack Surface
- Instance metadata access
- Bootstrap (User Data)
- EBS data at rest
- Console/API misconfiguration

## Controls
- **IMDSv2 required**; no secrets in User Data.
- **EBS encryption** with account-default KMS.
- **Minimal privileges** (Phase 2 will refine IAM).
- **Backups via DLM**; restore runbook documented.

## Residual Risks
- Human error in console changes.
- Cost drift if instance left running.

## Next Steps (Phase 2)
- IAM hardening, logging/metrics, CI quality gates, policy as code.
