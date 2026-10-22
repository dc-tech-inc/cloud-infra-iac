# ADR 0002: Validate and test, never apply

Status: accepted

## Context
Applying would need real cloud accounts, credentials and billing, which a public reference repository must not carry.

## Decision
CI runs `terraform fmt`, `validate`, `terraform test` with `mock_provider`, tflint and checkov. Tests assert configuration-derived values and use `expect_failures` to prove that variable validations reject unsafe input (for example SSH open to `0.0.0.0/0`). No workflow has cloud credentials or an `apply` step.

## Consequences
We catch syntax errors, schema mismatches, unsafe defaults and regressions without any account. We cannot catch quota, IAM, regional availability or provider-side validation errors; this is stated in the README limitations.
