`docs(cost): add cost model levers and formulas`

# Cost Model (Levers & Formulas)

> Prices change over time. Keep this file formula-based.

## Levers
- **EC2 hours/day** (run vs hibernate)
- **EBS size (GiB)** and type (gp3)
- **Snapshot churn (GiB/day)**
- **Monitoring level** (Basic vs Detailed)

## Formulas (Qualitative)
- **EC2 cost ≈** instance_hour_rate × hours_run_per_day × days
- **EBS cost ≈** volume_gib × gib_month_rate × (days/30)
- **Snapshot cost ≈** daily_changed_gib × gib_month_rate × (days/30)
- **Data transfer (intra-AZ private)**: assumed **$0** in this design

## Guidance
- Keep the instance small; enforce hibernate when idle.
- Keep volumes small in dev; short snapshot retention.
- Consider Savings Plans/RI in later phases if usage becomes steady.
