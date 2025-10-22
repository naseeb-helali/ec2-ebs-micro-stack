`docs(adr): Spot is optional, only for interruptible tasks`

# ADR-005: Optional Spot Worker for Interruptible Tasks

- **Status:** Accepted
- **Context:** Some workloads can be interrupted (batch/cleanup).
- **Decision:** Keep core workload On-Demand; add a one-time Spot request for non-critical background tasks if needed.
- **Consequences:** Cost efficiency without risking core availability.
