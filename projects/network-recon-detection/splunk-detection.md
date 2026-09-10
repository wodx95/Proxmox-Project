# Splunk Port Scan Detection

This SPL search was created during the Network Reconnaissance and Detection lab.

It identifies source hosts attempting to connect to five or more unique TCP destination ports on the same destination host within a one-minute window.

## Detection Search

```spl
index=main host="ubuntu-client" "UFW BLOCK" "PROTO=TCP"
| rex "SRC=(?<src_ip>\d+\.\d+\.\d+\.\d+)"
| rex "DST=(?<dest_ip>\d+\.\d+\.\d+\.\d+)"
| rex "DPT=(?<dest_port>\d+)"
| bin _time span=1m
| stats count AS attempts dc(dest_port) AS unique_ports values(dest_port) AS ports by _time src_ip dest_ip
| where unique_ports >= 5
| sort - _time
```

## Alert Configuration

- Alert type: Scheduled
- Runs every 5 minutes
- Searches the previous 5 minutes
- Trigger condition: Number of results greater than 0
- Severity: Medium

The threshold of five unique ports was used for this lab and would require further tuning in a production environment.
