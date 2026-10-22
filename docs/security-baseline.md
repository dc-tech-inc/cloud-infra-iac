# Security baseline

Inspired by common hardening guidance (CIS-style); this is **not** a compliance claim or certification. Defensive controls only.

## Network (Terraform)

| Control | Where |
|---|---|
| SSH only from a specific admin CIDR; Terraform rejects `0.0.0.0/0` and `::/0` | `stacks/oci-paas/variables.tf` (`admin_cidr` validation), tested with `expect_failures` |
| Only 80/443 public; HTTP redirects to HTTPS | OCI security list, AWS listener, Cloudflare `always_use_https` |
| Default security group locked (AWS) / explicit deny-all rule (Azure NSG) | `modules/aws`, `modules/azure` |
| TLS 1.2+ and strict origin TLS | AWS listener policy, Azure storage, Cloudflare zone |
| Flow/request logging | GCP subnet flow logs, GCP backend service logging |

## Compute and host

| Control | Where |
|---|---|
| Legacy IMDS endpoints disabled; in-transit volume encryption | `oci_core_instance.paas` |
| Key-only SSH, no root login, no forwarding, low `MaxAuthTries` | `ansible/roles/hardening` |
| fail2ban for sshd, unattended security updates | same role |
| Network sysctl hardening (rp_filter, syncookies, no redirects) | same role |
| Docker socket reached through a read-only socket proxy, `no-new-privileges`, read-only app filesystem | `stacks/oci-paas/paas/compose.yaml` |

## Data

| Control | Where |
|---|---|
| Buckets private, versioned, encrypted | S3 public-access block + SSE; Azure `allow_nested_items_to_be_public = false`; GCP `public_access_prevention = enforced` |

## Supply chain and secrets

- gitleaks scans the full history in CI; the binary is a pinned release verified by sha256.
- Dependabot updates Actions, pip, Terraform providers and the compose images.
- No credentials in the repo: `.env.example` documents variable names with placeholders only.

## Accepted checkov findings

Findings are recorded here only after CI reports them. Each skip in `.checkov.yaml` must have a row below.

| Check | Reason |
|---|---|
| _none yet_ | |
