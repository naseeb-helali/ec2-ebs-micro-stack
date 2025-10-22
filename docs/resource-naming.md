`docs(naming): add lightweight resource naming guidance`

# Resource Naming (Lightweight)

## Goals
Discoverability and consistency while keeping names short.

## Pattern
`<project>-<env>-<role>-<seq>`

- `<project>`: `eems` (short for ec2-ebs-micro-stack)
- `<env>`: `dev`
- `<role>`: `web`, `vol`, `snap`
- `<seq>`: `01`, `02`...

## Examples
- Instance: `eems-dev-web-01`
- Volume:   `eems-dev-vol-01`
- Snapshot: `eems-dev-snap-2025-10-22`

> Tags remain the source of truth for automation; names are for human readability.
