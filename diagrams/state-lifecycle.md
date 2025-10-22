`docs(diagrams): add EC2 lifecycle including hibernate`

# EC2 Instance Lifecycle (with Hibernate)

```mermaid
stateDiagram-v2
  [*] --> Stopped
  Stopped --> Running: Start
  Running --> Rebooting: Reboot
  Rebooting --> Running: System OK
  Running --> Hibernate: Stop (Hibernate)
  Hibernate --> Running: Start (Resume RAM)
  Running --> Stopped: Stop
  Stopped --> Terminated: Terminate

```
## Notes

- Billing applies when Running/Rebooting and when Stopping for Hibernate operations occur.

- Hibernate preserves RAM contents on the root volume; suitable for fast warm-up.
