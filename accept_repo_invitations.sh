#!/bin/bash
set -euo pipefail

# Usage:
#   GITHUB_TOKEN="YourTokenHere" ./accept_repo_invitations.sh

# (c) Copyright 2025 Mathew Lodge
# Released under MIT open source license. See LICENSE file for details

: "${GITHUB_TOKEN:?Error: GITHUB_TOKEN is not set}"

API_URL="https://api.github.com"

echo "Fetching repository invitations..."

# Get all repo invitations (single page of up to 100 is usually enough -- just run again if you have >100 invitations)
invitations_json=$(curl -sS \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${API_URL}/user/repository_invitations")

# Extract invitation IDs
ids=$(echo "$invitations_json" | jq -r '.[].id')

if [[ -z "${ids// /}" ]]; then
  echo "No repository invitations found."
  exit 0
fi

echo "Found invitation IDs:"
echo "$ids"
echo

# Accept each invitation
while IFS= read -r id; do
  [[ -z "$id" ]] && continue
  echo "Accepting invitation $id..."
  status=$(curl -sS -o /dev/null -w "%{http_code}" \
    -X PATCH \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${API_URL}/user/repository_invitations/${id}")

  if [[ "$status" == "204" || "$status" == "200" ]]; then
    echo "✅ Accepted $id"
  else
    echo "⚠️  Failed to accept $id (HTTP $status)"
  fi
done <<< "$ids"

echo "Done."
