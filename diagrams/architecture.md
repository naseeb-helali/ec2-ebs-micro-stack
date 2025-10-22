`docs(diagrams): refine architecture diagram with Ops context`

# Architecture

```mermaid
flowchart LR
  subgraph AZ[Availability Zone]
    EC2[EC2 Web (IMDSv2, Hibernate)]
    EBS[(EBS gp3 - Encrypted)]
  end

  User[User] -->|HTTP| EC2
  EC2 <-->|I/O| EBS

  subgraph Ops[Operations]
    CW[CloudWatch Basic Monitoring]
    DLM[Snapshot DLM Policy]
    KMS[KMS (EBS Encryption)]
  end

  EC2 --> CW
  EBS --> DLM
  EBS --> KMS
