#!/usr/bin/env bash
# Run fmt, validate and the offline tests for every Terraform root in the repo.
# Needs only terraform >= 1.9 on PATH. Nothing here talks to a cloud API.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

dirs=(stacks/oci-paas modules/aws modules/azure modules/gcp modules/cloudflare)

terraform fmt -check -recursive

for dir in "${dirs[@]}"; do
  echo "==> ${dir}"
  terraform -chdir="$dir" init -backend=false -input=false >/dev/null
  terraform -chdir="$dir" validate
  terraform -chdir="$dir" test
done

echo "All Terraform roots passed."
