`docs(adr): stick to Basic Monitoring in Phase 1`

# ADR-004: Basic Monitoring Only (Phase 1)

- **Status:** Accepted
- **Context:** Keep costs minimal while preserving basic health visibility.
- **Decision:** Use CloudWatch **Basic Monitoring** and a system status check alarm reference.
- **Consequences:** Coarser granularity; introduce Detailed Monitoring in Phase 2 if needed.
