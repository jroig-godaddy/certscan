# Repo scan
run it like this: 
```
./scanner.sh https://github.secureserver.net/PC/paylinks-api
```
... that'll run tartufo / gitleaks / trufflehog, then follow up with a local cert scan.


# CertScan
Scans for non-expired certs in a list of github repos defined in repolist.txt. 

Works off the assumption that all the expired certs are a non-issue, but we might need to expire and recreate active certs.

Usage: ```sh certscan.sh```

... generates output.csv

