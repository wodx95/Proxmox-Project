# Splunk SSH Investigation – Quick Reference

This file contains the main SPL searches used during the investigation of SSH activity on the public-facing VPS.

## Base Search

Used to view authentication events collected from the VPS.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf"
```

## Failed SSH Attempts

Counts failed password authentication attempts and the number of unique source IP addresses.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf" "Failed password"
| rex "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| stats count AS "Failed SSH Attempts" dc(src_ip) AS "Unique Source IPs"
```

## Failed SSH Attempts Over Time

Groups failed authentication attempts into one-hour intervals.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf" "Failed password"
| timechart span=1h count AS "Failed SSH Attempts"
```

## Most Targeted Usernames

Identifies the usernames most frequently targeted by failed SSH authentication attempts.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf" "Failed password"
| rex "Failed password for (?:invalid user )?(?<username>\S+)"
| stats count AS Attempts by username
| sort - Attempts
| head 15
```

## Top Attacking Source IP Addresses

Identifies source IP addresses generating the highest number of failed SSH authentication attempts.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf" "Failed password"
| rex "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| iplocation src_ip
| stats count AS "Failed Attempts" by src_ip Country
| sort - "Failed Attempts"
| head 15
```

## Geographic Distribution of SSH Attempts

Uses IP geolocation to visualise the geographic distribution of source IP addresses.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf" "Failed password"
| rex "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| iplocation src_ip
| geostats count
```

## SSH Attempts by Country

Groups failed SSH authentication attempts by country.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf" "Failed password"
| rex "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| iplocation src_ip
| stats count AS "Failed SSH Attempts" dc(src_ip) AS "Unique Source IPs" by Country
| sort - "Failed SSH Attempts"
```

## Successful SSH Logins

Identifies successful SSH authentications, including the authentication method used.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf" "Accepted"
| rex "Accepted (?<auth_method>\S+) for (?<username>\S+) from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| stats count AS successful_logins values(auth_method) AS auth_method by src_ip username
| sort - successful_logins
```

## Successful Public-Key Authentication

Used after SSH hardening to confirm that public-key authentication remained functional.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf"
("Accepted publickey" OR "Accepted password")
| rex "Accepted (?<auth_method>\S+) for (?<user>\S+) from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| table _time user src_ip auth_method
| sort - _time
```

## Post-Hardening – Failed Password Attempts

Used after disabling password authentication to check for new `Failed password` events.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf" "Failed password"
| table _time _raw
| sort - _time
```

## Post-Hardening – Continued SSH Scanning

Shows invalid username and pre-authentication activity that continued after password authentication was disabled.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf"
("Invalid user" OR "preauth")
| table _time _raw
| sort - _time
```

## Invalid User Activity

Extracts targeted invalid usernames and source IP addresses.

```spl
index=main sourcetype=linux_secure host="vps-1e729caf" "Invalid user"
| rex "Invalid user (?<username>\S+) from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| stats count AS Attempts dc(src_ip) AS "Unique IPs" by username
| sort - Attempts
| head 20
```

---

These searches were used to investigate SSH brute-force activity, build the VPS SSH Security Investigation dashboard, and compare authentication activity before and after SSH hardening.
