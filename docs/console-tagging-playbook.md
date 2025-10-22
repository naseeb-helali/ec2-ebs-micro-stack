`docs(playbook): add console steps to apply and audit tags`

# Console Tagging Playbook

## 1) EC2 Instance (at launch)
- Step: EC2 Console → **Launch instance**.
- Section: **Tags** → Add:
  - `Project=ec2-ebs-micro-stack`
  - `Owner=naseeb.helali`
  - `Env=dev`
  - `Teardown=safe`

## 2) EBS Volume (at launch)
- Same wizard → **Storage** → ensure the root volume is **Encrypted** (account default KMS).
- Section: **Tags** for the volume → Add:
  - `Project=ec2-ebs-micro-stack`
  - `Owner=naseeb.helali`
  - `Env=dev`
  - `Backup=dlm-daily`
  - `Teardown=safe`

## 3) Snapshots (post-DLM)
- After DLM runs, open **Snapshots** and verify tags were inherited or apply them if needed:
  - `Project`, `Owner`, `Env`, `Backup`

## 4) Bulk Audit (Tag Editor)
- AWS Console → **Tag Editor** → Regions: (select region) → Resource types: EC2, EBS, Snapshots
- **Search resources** → Filter by `Project=ec2-ebs-micro-stack`
- Fix missing tags by **Add tags to selected resources**.

## 5) Cost Awareness (later)
- **Cost Explorer** → Tag filtering: ensure `Project` appears as a cost allocation tag (Phase 2).
