`docs(spot): add brief interruption handling reference`

# Spot Interruption Handling (Brief)

## Goal
React to the **2-minute termination notice** to shut down cleanly.

## Pattern
1. Obtain an **IMDSv2 token**.
2. Poll `http://169.254.169.254/latest/meta-data/spot/instance-action`.
3. If a JSON response is returned, log and **gracefully exit** your work loop.

## Notes
- Keep work **idempotent**; do not rely on local disk for durable state.
- For production-grade pipelines, push outputs off the instance (e.g., to external storage) — deferred to Phase 2 scope.
