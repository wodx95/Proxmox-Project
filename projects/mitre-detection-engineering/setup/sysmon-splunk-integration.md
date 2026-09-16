# Phase 1 – Sysmon Integration with Splunk

## Objective

Deploy Sysmon on the Windows Server 2022 endpoint and integrate its telemetry with the existing Splunk environment to provide enhanced endpoint visibility for future MITRE ATT&CK-based detection engineering.

## Sysmon Deployment

Before deployment, the endpoint was checked to confirm that no Sysmon service was already installed.

Sysmon v15.22 was downloaded from Microsoft Sysinternals and installed using the SwiftOnSecurity `sysmon-config` community configuration as the initial monitoring baseline.

The configuration validated successfully and both the Sysmon service and driver started correctly. Local telemetry generation was then verified through Windows Event Viewer under:

```text
Applications and Services Logs
└── Microsoft
    └── Windows
        └── Sysmon
            └── Operational
```

Initial events included Sysmon Event ID 1 (Process Creation) and Event ID 22 (DNS Query).

## Splunk Universal Forwarder Integration

The existing Splunk Universal Forwarder configuration on `Win-Serv-22` was extended to collect the Sysmon Operational channel.

The following stanza was added to `inputs.conf`:

```ini
[WinEventLog://Microsoft-Windows-Sysmon/Operational]
checkpointInterval = 5
current_only = 0
disabled = 0
start_from = oldest
```

The effective configuration was checked with Splunk `btool`, after which the Splunk Universal Forwarder service was restarted and verified as running.

## Splunk Verification

End-to-end ingestion was confirmed using the following search:

```spl
index=main host="Win-Serv-22" Sysmon
```

Sysmon events were successfully received with the source:

```text
WinEventLog:Microsoft-Windows-Sysmon/Operational
```

A second SPL search was used to identify the event types being collected:

```spl
index=main host="Win-Serv-22"
source="WinEventLog:Microsoft-Windows-Sysmon/Operational"
| stats count by EventCode
| sort EventCode
```

During validation, Splunk received Process Creation (Event ID 1), File Creation (Event ID 11), and DNS Query (Event ID 22) telemetry.

## Result

The complete telemetry pipeline was successfully validated:

```text
Windows activity
      ↓
    Sysmon
      ↓
Splunk Universal Forwarder
      ↓
Splunk Enterprise
```

This integration establishes the endpoint telemetry foundation for the next phase of the project, where Sysmon data will be used to develop, test and validate MITRE ATT&CK-mapped detections in Splunk.

A detailed six-page PDF with deployment and validation screenshots is maintained as supporting project documentation.
