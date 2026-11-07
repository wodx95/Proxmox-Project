# Splunk Environment Setup

This project documents the deployment and configuration of the Splunk environment used as the central SIEM platform within the Proxmox lab.

The environment includes Splunk Enterprise, Splunk Enterprise Security, Universal Forwarders, Windows and Linux log collection, and centralised security monitoring.

## Splunk Server

- Splunk Enterprise installed on a dedicated Ubuntu Server VM (`192.168.50.10`) inside the isolated lab network
- Splunk Enterprise Security (ES) installed for security monitoring, investigation and incident response features
- Splunk configured to start automatically at boot
- Receiving enabled on **TCP 9997** for Universal Forwarder traffic
- Ubuntu switched from the graphical target to CLI-only mode to free resources, which made the Splunk web interface noticeably more responsive

## Universal Forwarders

| Endpoint | Data collected | Add-on |
|---|---|---|
| Windows Server 2022 (`Win-Serv-22`) | Windows Event Logs (Security, System, Application); Sysmon added later | Splunk Add-on for Microsoft Windows |
| Windows 10 | Windows Event Logs | Splunk Add-on for Microsoft Windows |
| Ubuntu endpoint | Linux authentication and system logs (`linux_secure`, syslog); UFW firewall logs added later | Splunk Add-on for Unix and Linux |
| Public VPS | `/var/log/auth.log` via WireGuard tunnel | – |

Each forwarder was verified in Splunk by checking incoming events by host and sourcetype. The add-ons parse and normalise the data so that it can be used by Splunk Enterprise Security.

## Data Flow

```text
Lab endpoints (Windows / Linux)
        ↓
Splunk Universal Forwarder
        ↓  TCP 9997
Splunk Enterprise + Enterprise Security
        ↓
SPL searches, dashboards and alerts
```

## Planned Improvements

- Move data from the default `main` index into dedicated indexes (for example `wineventlog`, `linux`, `sysmon`, `vps`) with appropriate retention
- Apply Splunk Common Information Model (CIM) field names more consistently across data sources
- Back up Splunk configuration and saved searches

## Documentation

Full step-by-step documentation of the Splunk environment setup is available below:

[Splunk Environment Setup – Full Documentation](./Splunk%20Environment%20Setup.pdf)
