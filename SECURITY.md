# Security policy

This repository contains reference infrastructure code only. It holds no credentials and has never been applied to a real cloud account.

## Reporting a vulnerability

Please use GitHub's private vulnerability reporting ("Security" tab, "Report a vulnerability") instead of a public issue. We aim to acknowledge reports within a few business days.

Useful reports include insecure defaults in the modules, a hardening step that weakens a host, or a CI workflow that could leak secrets.

## Scope

In scope: Terraform in `stacks/` and `modules/`, the Ansible role, the pipelines and the scripts. Out of scope: the third-party providers, images and actions this repository references.
