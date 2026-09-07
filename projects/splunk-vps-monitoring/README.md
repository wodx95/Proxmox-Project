# Splunk VPS Security Monitoring

This project documents the integration of a public-facing VPS with my Splunk environment and the investigation of real-world security activity observed on the server.

The project focuses on collecting and analysing SSH authentication logs, investigating brute-force activity, visualising the results in Splunk, and evaluating the impact of SSH hardening.

## Project Overview

The VPS hosts a public Luanti gaming server and is exposed to the Internet. Security logs from the server are forwarded to Splunk Enterprise running within the Proxmox lab environment.

This provides an opportunity to analyse real Internet-generated security activity alongside controlled security scenarios performed within the lab.

## Architecture

The public VPS is connected to the internal Splunk environment through a dedicated WireGuard tunnel.

A Splunk Universal Forwarder installed on the VPS collects security logs and forwards them to the Splunk Server. pfSense firewall rules restrict the VPS connection so that it can communicate only with the Splunk receiver on TCP port 9997.

**Data flow:**

Public VPS → Splunk Universal Forwarder → WireGuard VPN → pfSense → Splunk Enterprise

## Splunk Integration

I installed Splunk Universal Forwarder on the Ubuntu VPS to collect and forward security-relevant logs to my Splunk environment.

To keep the public server isolated from the internal lab, a dedicated WireGuard tunnel was configured between the VPS and pfSense. Firewall rules allow the VPS to communicate only with the Splunk receiver on TCP port 9997.

After configuring the forwarder, I verified the connection to the Splunk Server and confirmed that authentication logs from the VPS were successfully being received and indexed in Splunk.

## Documentation

### VPS Integration

Full step-by-step documentation covering the integration of the public VPS with Splunk, including SSH key configuration, Splunk Universal Forwarder setup, WireGuard connectivity, pfSense firewall configuration and log forwarding verification:

 [VPS into Splunk – Full Documentation](./VPS%20into%20Splunk.pdf)

### SSH Security Investigation

Full investigation of real-world SSH activity observed on the public-facing VPS, including brute-force activity, targeted usernames, source IP analysis, geographic distribution, SSH hardening and post-hardening comparison:

 [Splunk – Investigating VPS SSH Connections](./Splunk-%20Investigating%20VPS%20SSH%20connections.pdf)

### SPL Quick Reference

The main SPL searches used throughout the SSH investigation, collected in one place for quick reference:

 [Splunk SSH Investigation – Quick Reference](./splunk-searches.md)

### SSH Hardening Script

A reusable Bash script based on the SSH hardening process performed during the investigation. The script disables password-based SSH authentication and includes additional backup and configuration validation checks for safer reuse:

 [SSH Password Authentication Hardening Script](./disable-ssh-password-auth.sh)
