# Contributing

1. Branch from `main` (`feat/<scope>` or `fix/<scope>`).
2. Use [conventional commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, `chore:`).
3. Run `scripts/validate-all.sh` and, for Ansible changes, `molecule test` in `ansible/roles/hardening`.
4. Never commit credentials, real IPs or real domains. Use `example.com` and RFC 5737 ranges (`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`).
5. Open a pull request. All CI checks must be green; merges use a merge commit.

New checkov skips need a one-line reason in `docs/security-baseline.md`.
