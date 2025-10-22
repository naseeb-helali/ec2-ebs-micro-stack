`docs(adr): use encrypted gp3 volumes`

# ADR-002: Use Encrypted gp3 Volumes

- **Status:** Accepted
- **Context:** Persistent storage with balanced IO and default encryption.
- **Decision:** Use **gp3** with account-default **KMS** encryption.
- **Consequences:** Transparent encryption; predictable baseline performance; can tune gp3 throughput/IOPS later.
