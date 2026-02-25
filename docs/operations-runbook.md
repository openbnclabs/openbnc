# openbnc Operations Runbook

This runbook is for operators who maintain availability, security posture, and incident response.

Last verified: **February 18, 2026**.

## Scope

Use this document for day-2 operations:

- starting and supervising runtime
- health checks and diagnostics
- safe rollout and rollback
- incident triage and recovery

For first-time installation, start from [one-click-bootstrap.md](one-click-bootstrap.md).

## Runtime Modes

| Mode | Command | When to use |
|---|---|---|
| Foreground runtime | `openbnc daemon` | local debugging, short-lived sessions |
| Foreground gateway only | `openbnc gateway` | webhook endpoint testing |
| User service | `openbnc service install && openbnc service start` | persistent operator-managed runtime |

## Baseline Operator Checklist

1. Validate configuration:

```bash
openbnc status
```

2. Verify diagnostics:

```bash
openbnc doctor
openbnc channel doctor
```

3. Start runtime:

```bash
openbnc daemon
```

4. For persistent user session service:

```bash
openbnc service install
openbnc service start
openbnc service status
```

## Health and State Signals

| Signal | Command / File | Expected |
|---|---|---|
| Config validity | `openbnc doctor` | no critical errors |
| Channel connectivity | `openbnc channel doctor` | configured channels healthy |
| Runtime summary | `openbnc status` | expected provider/model/channels |
| Daemon heartbeat/state | `~/.openbnc/daemon_state.json` | file updates periodically |

## Logs and Diagnostics

### macOS / Windows (service wrapper logs)

- `~/.openbnc/logs/daemon.stdout.log`
- `~/.openbnc/logs/daemon.stderr.log`

### Linux (systemd user service)

```bash
journalctl --user -u openbnc.service -f
```

## Incident Triage Flow (Fast Path)

1. Snapshot system state:

```bash
openbnc status
openbnc doctor
openbnc channel doctor
```

2. Check service state:

```bash
openbnc service status
```

3. If service is unhealthy, restart cleanly:

```bash
openbnc service stop
openbnc service start
```

4. If channels still fail, verify allowlists and credentials in `~/.openbnc/config.toml`.

5. If gateway is involved, verify bind/auth settings (`[gateway]`) and local reachability.

## Safe Change Procedure

Before applying config changes:

1. backup `~/.openbnc/config.toml`
2. apply one logical change at a time
3. run `openbnc doctor`
4. restart daemon/service
5. verify with `status` + `channel doctor`

## Rollback Procedure

If a rollout regresses behavior:

1. restore previous `config.toml`
2. restart runtime (`daemon` or `service`)
3. confirm recovery via `doctor` and channel health checks
4. document incident root cause and mitigation

## Related Docs

- [one-click-bootstrap.md](one-click-bootstrap.md)
- [troubleshooting.md](troubleshooting.md)
- [config-reference.md](config-reference.md)
- [commands-reference.md](commands-reference.md)
