# Splunk VPS Security Monitoring

This project documents the integration of a public-facing VPS with my Splunk environment and the investigation of real-world security activity observed on the server.

The project focuses on collecting and analysing SSH authentication logs, investigating brute-force activity, visualising the results in Splunk, and evaluating the impact of SSH hardening.

## Project Overview

The VPS hosts a public Luanti gaming server and is exposed to the Internet. Security logs from the server are forwarded to Splunk Enterprise running within the Proxmox lab environment.

This provides an opportunity to analyse real Internet-generated security activity alongside controlled security scenarios performed within the lab.
