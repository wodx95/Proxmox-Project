# MITRE ATT&CK Detection Engineering

This project extends the existing Proxmox SOC lab from individual attack scenarios into a structured detection engineering workflow using **Sysmon, Splunk Enterprise and MITRE ATT&CK**.

The workflow used throughout the project is:

**Hypothesis → Telemetry → SPL Detection → Controlled Test → Validation → Alerting → Documentation**

## Environment

- Windows Server 2022 endpoint (`Win-Serv-22`)
- Sysmon v15.22 with SwiftOnSecurity configuration
- Splunk Universal Forwarder
- Splunk Enterprise / Splunk Enterprise Security
- Isolated Proxmox SOC network

Sysmon telemetry from `Microsoft-Windows-Sysmon/Operational` is collected by the Universal Forwarder and sent to Splunk for analysis.

## Phase 1 – Sysmon Integration

Sysmon was installed on `Win-Serv-22` to provide detailed endpoint telemetry. The existing Splunk Universal Forwarder was configured to collect the Sysmon Operational event channel.

End-to-end ingestion was verified in Splunk using Sysmon Event IDs including:

- **Event ID 1** – Process Creation
- **Event ID 11** – File Creation
- **Event ID 22** – DNS Query

This established the telemetry foundation for ATT&CK-mapped detection engineering.

Documentation: [`Phase1_Sysmon_Integration.pdf`](Phase1_Sysmon_Integration.pdf)

Technical setup: [`setup/sysmon-splunk-integration.md`](setup/sysmon-splunk-integration.md)

## Phase 2 – Suspicious PowerShell Encoded Command Detection

**MITRE ATT&CK:** T1059.001 – Command and Scripting Interpreter: PowerShell

The first detection focuses on PowerShell execution using encoded command-line arguments. Encoded PowerShell is not inherently malicious, but it is useful detection telemetry because attackers may use encoding to obscure command content.

### Detection development

Sysmon **Event ID 1 (Process Creation)** was used because it records process execution details including the executable image, command line, user and parent process.

A baseline search initially showed both normal Windows PowerShell and Splunk Universal Forwarder PowerShell activity. Splunk-generated PowerShell processes were excluded to reduce known benign noise.

The final detection searches for PowerShell processes containing common encoded-command arguments:

- `-EncodedCommand`
- `-enc`
- `-enco`

Final SPL: [`detection.spl`](detection.spl)

### Controlled validation

A harmless PowerShell test script creates a Base64-encoded command which outputs `DetectionLab-Test`, then launches it with `powershell.exe -EncodedCommand`.

Test script: [`test-powershell.ps1`](test-powershell.ps1)

The generated execution was recorded by Sysmon and successfully returned by the Splunk detection. The test was repeated using the shorter `-enc` form to verify that the detection covered common argument variations.

### Alerting

The SPL was saved as a scheduled Splunk alert named:

`Suspicious PowerShell Encoded Command - T1059.001`

The alert runs every five minutes over the previous five-minute window and triggers when one or more matching events are found. Triggered Alerts was enabled with **Medium** severity.

Final validation confirmed that repeated controlled executions were detected and the scheduled alert triggered successfully.

Full documentation: [`Phase2_PowerShell_Detection_T1059.001.pdf`](Phase2_PowerShell_Detection_T1059.001.pdf)

### Limitations

This is a behavioural detection rather than proof of malicious activity. Legitimate administration tools may use encoded PowerShell, so production deployment would require further tuning and allow-listing. The current rule also focuses on Windows PowerShell process creation and may require extension for PowerShell Core (`pwsh.exe`).

## Detection Coverage

| ATT&CK Technique | Detection | Telemetry | Status |
|---|---|---|---|
| T1059.001 | PowerShell Encoded Command | Sysmon Event ID 1 | **Completed & validated** |
| T1547.001 | Registry Run Keys / Startup Folder | Sysmon Registry Events | Planned |
| T1003.001 | LSASS Memory | Sysmon Event ID 10 | Planned |
| T1021.001 | Remote Desktop Protocol | Windows Security Events | Existing lab detection |

## Repository Structure

```text
mitre-detection-engineering/
├── README.md
├── Phase1_Sysmon_Integration.pdf
├── Phase2_PowerShell_Detection_T1059.001.pdf
├── detection.spl
├── test-powershell.ps1
└── setup/
    └── sysmon-splunk-integration.md
```

Each detection is developed from telemetry through controlled validation rather than being added as an untested rule.
