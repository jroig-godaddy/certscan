#!/usr/bin/env bash
git clone $1 tmp
cd tmp;
cp ../tartufo.toml ./tartufo.toml


gitleaksReport="$(mktemp /tmp/gitleaks.$$)"
gitleaks detect -f json -r $gitleaksReport &> /dev/null
GITLEAKS=$(cat $gitleaksReport)
GITLEAKS_JSON=$(jq 'unique_by(.Match)' <<<"$GITLEAKS")
TARTUFO_JSON=$(tartufo -of json scan-local-repo . | jq '.found_issues | unique_by(.signature)')
TRUFFLEHOG_JSON=$(truffleHog git file://. --json --exclude-paths ../excludepaths.txt | jq -s '.')

jq -s 'add' <(echo "$GITLEAKS_JSON") <(echo "$TARTUFO_JSON") <(echo "$TRUFFLEHOG_JSON") 

rm $gitleaksReport
sh ../localcertscan.sh

cd ..
rm -rf tmp;
