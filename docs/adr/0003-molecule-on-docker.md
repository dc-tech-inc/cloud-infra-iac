# ADR 0003: Molecule on Docker for the hardening role

Status: accepted

## Context
The hardening role should be tested before it touches a host, with no VM required.

## Decision
Use Molecule with the Docker driver on an Ubuntu 22.04 image. The scenario converges the role, checks idempotence, and verifies the rendered configuration (including `sshd -t`). Service reloads and `sysctl --system` are skipped when `ansible_virtualization_type` is a container.

## Consequences
Fast, free-tier friendly and deterministic. It does not prove runtime behaviour such as fail2ban banning or sysctl taking effect; those need a VM-based scenario (roadmap). Molecule runs only on pull requests and manual dispatch to conserve private-repo minutes.
