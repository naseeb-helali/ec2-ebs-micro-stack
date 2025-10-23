`feat(userdata): add Spot worker script with IMDSv2 polling and safe shutdown`

```bash
#!/bin/bash
set -euxo pipefail

# NOTE: Keep this script free of secrets. IMDSv2 is required at launch.

LOG="/var/log/spot-worker.log"
INTLOG="/var/log/spot-interrupt.log"

echo "[$(date -Is)] spot-worker: bootstrapping..." | tee -a "$LOG"

# Lightweight task example (adjust or replace in Phase 2 CI)
# Here we just print system info and simulate some work.
uname -a | tee -a "$LOG"
echo "[$(date -Is)] spot-worker: starting looped work..." | tee -a "$LOG"

# Function to get IMDSv2 token
get_token() {
  curl -s -X PUT "http://169.254.169.254/latest/api/token" \
    -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"
}

TOKEN="$(get_token || true)"

# Poll for interruption notice while doing trivial work
for i in $(seq 1 120); do  # ~ simulate up to N cycles
  # Check for interruption notice
  if [[ -n "${TOKEN:-}" ]]; then
    NOTICE=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
      http://169.254.169.254/latest/meta-data/spot/instance-action || true)
  else
    NOTICE=""  # if token retrieval failed, skip (IMDSv2 is required; token usually succeeds)
  fi

  if [[ -n "$NOTICE" ]]; then
    echo "[$(date -Is)] spot-worker: INTERRUPTION NOTICE -> $NOTICE" | tee -a "$INTLOG" "$LOG"
    echo "[$(date -Is)] spot-worker: performing quick cleanup..." | tee -a "$LOG"
    # Place any quick cleanup here (delete temp files, flush queues, etc.)
    echo "[$(date -Is)] spot-worker: exiting before termination." | tee -a "$LOG"
    exit 0
  fi

  # Simulated unit of work (sleep 5s)
  sleep 5
  echo "[$(date -Is)] spot-worker: heartbeat $i" | tee -a "$LOG"
done

echo "[$(date -Is)] spot-worker: completed loop without interruption." | tee -a "$LOG"
