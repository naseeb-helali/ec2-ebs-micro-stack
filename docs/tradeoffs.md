`docs(arch): document key design trade-offs`

# Design Trade-offs

| Decision | Option A | Option B | Rationale | Risk | Mitigation |
|---|---|---|---|---|---|
| Compute purchase | On-Demand (Phase 1) | Spot for core workload | Predictable availability in a baseline | Higher cost vs Spot | Add Spot only for interruptible tasks (optional worker) |
| Volume type | gp3 | io2 | Balanced performance/cost in dev | Lower IOPS headroom | Upgrade to io2 if workload demands it |
| Monitoring level | Basic | Detailed (1-min) | Zero extra cost in Phase 1 | Coarser signals | Introduce Detailed in Phase 2 if needed |
| Backups | DLM daily, short retention | Manual snapshots | Automated & consistent | Possible data churn | Keep volumes small; adjust retention later |
| Shutdown strategy | Hibernate when idle | Stop without hibernate | Faster resume | Hibernate support varies by instance/AMI | Fallback to Stop if unsupported |
