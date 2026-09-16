# MITRE ATT&CK Detection Engineering

This project extends the existing Proxmox SOC lab from individual attack scenarios into a structured detection engineering workflow using **Sysmon, Splunk Enterprise and MITRE ATT&CK**.

The goal is to develop a small number of well-tested detections and document the complete process from telemetry collection through detection development and validation.

## Detection Engineering Workflow

**Hypothesis → Telemetry → SPL Detection → Controlled Test → Validation → Documentation**

Rather than creating a large collection of untested rules, each detection is developed and validated against activity generated inside the isolated SOC lab.

## Environment

- Windows Server 2022 endpoint (`Win-Serv-22`)
- Sysmon v15.22
- SwiftOnSecurity Sysmon configuration baseline
- Splunk Universal Forwarder
- Splunk Enterprise / Splunk Enterprise Security
- Isolated Proxmox SOC network

Sysmon telemetry is collected from `Microsoft-Windows-Sysmon/Operational` by the existing Splunk Universal Forwarder and forwarded to the Splunk environment for analysis.

## Phase 1 – Sysmon Integration

Sysmon was deployed to the Windows Server 2022 endpoint and configured using the SwiftOnSecurity community configuration as an initial telemetry baseline.

The Splunk Universal Forwarder was then configured to collect the Sysmon Operational event channel. End-to-end ingestion was verified in Splunk, including:

- Event ID 1 – Process Creation
- Event ID 11 – File Creation
- Event ID 22 – DNS Query

This establishes the endpoint telemetry foundation required for subsequent ATT&CK-mapped detections.

See: [`setup/sysmon-splunk-integration.md`](setup/sysmon-splunk-integration.md)

## Planned Detection Coverage

| ATT&CK Technique | Detection | Primary Sysmon Telemetry | Status |
|---|---|---|---|
| T1059.001 | PowerShell | Event ID 1 – Process Creation | Planned |
| T1547.001 | Registry Run Keys / Startup Folder | Registry Events | Planned |
| T1003.001 | LSASS Memory | Event ID 10 – Process Access | Planned |
| T1021.001 | Remote Desktop Protocol | Windows Security Events | Existing lab detection |

## Repository Structure

```text
mitre-detection-engineering/
├── README.md
├── setup/
│   └── sysmon-splunk-integration.md
├── detections/
└── spl/
```

Each detection will document its ATT&CK mapping, hypothesis, data source, SPL query, controlled validation activity, results, false-positive considerations and limitations.
