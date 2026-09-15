# RDP Brute Force Detection

This project demonstrates the detection of an RDP brute-force attack against a Windows Server 2022 system using Windows Security telemetry and Splunk Enterprise.

## Scenario

A Kali Linux VM was used to perform controlled RDP authentication attempts against a dedicated `testuser` account on Windows Server 2022.

THC Hydra was then used with a small custom password list to generate multiple failed authentication attempts. Windows Security logs were collected using the Splunk Universal Forwarder and analysed in Splunk Enterprise.

## Detection

The failed authentication attempts generated Windows Security Event ID 4625.

Splunk analysis identified repeated failed logons against the `testuser` account originating from the Kali attacker at `192.168.50.100`.

A behavioural detection was created to identify five or more failed authentication attempts from the same source IP and account.

The detection was configured as a scheduled High-severity Splunk alert. After repeating the RDP brute-force simulation, the alert triggered successfully.

## Detection Search

```spl
index=main host="Win-Serv-22" EventCode=4625
| eval Account_Name=mvfilter(Account_Name!="-")
| stats count by Source_Network_Address Account_Name
| where count >= 5
```

## Skills Practised

- Windows Security Event Log analysis
- RDP authentication monitoring
- Splunk log analysis
- SPL
- Behaviour-based detection
- Brute-force attack detection
- Alert creation and validation
- SOC detection workflow

## Documentation

Full step-by-step documentation of the RDP authentication attack, Windows Security event investigation, detection creation and automated alert testing:

[RDP Brute Force Detection – Full Documentation](./RDP-Brute-Force-Detection.pdf)

### Splunk Detection

The SPL search and alert configuration used to detect repeated failed RDP authentication attempts:

[Splunk RDP Brute Force Detection](./splunk-detection.md)
