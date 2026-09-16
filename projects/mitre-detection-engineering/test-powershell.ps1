# Controlled PowerShell test for MITRE ATT&CK T1059.001 detection
# Generates an encoded PowerShell command for Sysmon/Splunk telemetry.

$cmd = 'Write-Output "DetectionLab-Test"'
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($cmd))
powershell.exe -EncodedCommand $encoded
