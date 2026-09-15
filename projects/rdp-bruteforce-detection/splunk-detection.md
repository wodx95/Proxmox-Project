# Splunk RDP Brute Force Detection

## Purpose

Detect repeated failed Windows authentication attempts that may indicate an RDP brute-force or password-guessing attack.

## Detection Search

```spl
index=main host="Win-Serv-22" EventCode=4625
| eval Account_Name=mvfilter(Account_Name!="-")
| stats count by Source_Network_Address Account_Name
| where count >= 5
```

## Detection Logic

The search identifies Windows Security Event ID 4625 events and groups failed authentication attempts by source IP address and target account.

The detection triggers when five or more failed logon attempts are observed from the same source against the same account.

## Alert Configuration

- **Alert:** RDP Brute Force - Multiple Failed Logons
- **Type:** Scheduled
- **Schedule:** Every 5 minutes
- **Time Range:** Last 5 minutes
- **Trigger Condition:** Number of results greater than 0
- **Severity:** High
- **Action:** Add to Triggered Alerts

## Validation

The detection was validated by repeating the controlled RDP authentication attack from Kali Linux.

Seven failed authentication attempts against `testuser` were detected from `192.168.50.100`, and the scheduled Splunk alert triggered successfully.
