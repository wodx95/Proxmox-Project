# Proxmox Home Lab

This repository documents the deployment of a collaborative cybersecurity home lab built using Proxmox.

Here I document my own cybersecurity projects, practical labs, and experiments carried out within this environment.

The lab started as a way to gain practical experience with virtualisation, networking and server administration, and has gradually developed into an environment where I can practise both offensive and defensive security techniques.

## Lab Environment

The environment currently includes:

- Proxmox VE as the virtualisation platform
- pfSense for routing, firewalling and network isolation
- Splunk Enterprise as the central SIEM platform
- Splunk Enterprise Security
- Splunk Universal Forwarders on monitored endpoints
- Windows Server 2022
- Windows 10
- Ubuntu Linux systems
- Kali Linux
- WireGuard VPN
- Windows Event Log monitoring
- Linux authentication and system log monitoring
- Custom application log monitoring
- A public-facing VPS used for real-world security monitoring

## Splunk & Security Monitoring

A major part of my work in the lab focuses on security monitoring using Splunk.

I configured a central Splunk environment and connected multiple Windows and Linux systems using Splunk Universal Forwarders. This allows me to collect, search and analyse security events from across the lab.

Some of the projects and scenarios I have worked on include:

- Network reconnaissance and detection
- SSH brute-force investigation
- SSH hardening and before/after analysis
- Windows and Linux log monitoring
- Analysis of source IPs, targeted usernames and authentication activity
- Monitoring a public-facing VPS
- Application log monitoring
- Building SPL searches, visualisations and dashboards

## Current Project – Public VPS Monitoring

My current project focuses on monitoring a public-facing VPS using Splunk.

Within the first 48 hours of monitoring, more than 7,000 failed SSH password attempts were recorded. I used Splunk to investigate the activity and then hardened the server by moving from password-based SSH authentication to key-based authentication only.

The project is now being expanded to monitor additional network and application activity.

## Skills Practised

- SIEM and log analysis
- SPL
- Security monitoring and investigation
- Splunk Universal Forwarders
- Dashboard creation
- Linux and Windows administration
- Network security
- Firewall configuration
- Security hardening
- Virtualisation
- Offensive and defensive security

## Projects

###  Lab Environment Setup

Setup of the virtualised cybersecurity lab, including Proxmox networking, isolated lab infrastructure, virtual machines and connectivity testing.

 [View Lab Environment Project](./projects/lab-environment/)

###  Splunk Environment Setup

Deployment of the central Splunk SIEM environment, including Splunk Enterprise, Enterprise Security, Universal Forwarders and Windows/Linux log collection.

 [View Splunk Environment Project](./projects/splunk-environment/)

###  Splunk VPS Security Monitoring

Integration and monitoring of a public-facing VPS, including real-world SSH brute-force investigation, Splunk dashboards, SSH hardening, post-hardening analysis, SPL searches and a reusable hardening script.

 [View VPS Security Monitoring Project](./projects/splunk-vps-monitoring/)


## Collaboration

The underlying home lab infrastructure was built collaboratively with [@SiwySec](https://github.com/SiwySec).

The security projects, Splunk investigations and documentation presented in this repository represent my own work within the shared lab environment.
