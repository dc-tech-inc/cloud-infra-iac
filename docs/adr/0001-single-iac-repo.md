# ADR 0001: One repository for OCI and multi-cloud IaC

Status: accepted

## Context
The OCI PaaS stack and the AWS/Azure/GCP/Cloudflare modules share the same tooling (Terraform, Ansible) and the same CI checks (fmt, validate, tflint, checkov).

## Decision
Keep them in one repository: `stacks/` for a composed, opinionated stack and `modules/` for small reusable building blocks. `pipelines/` and `ansible/` are shared.

## Consequences
One CI definition and one security baseline to maintain. The cost is a matrix job per root; changes to one cloud re-run only that root's job in practice thanks to the matrix split.
