# pcd-infrastructure

Reference example for the Automating Private Cloud Director CI/CD blog series.

This repository contains a tested example of a GitOps pipeline that manages
network and security infrastructure inside a single PCD tenant, using
Terraform and GitHub Actions. It is intended to be read and copied, not
forked and run in place. The example pipeline workflow lives under
`examples/github-actions/` rather than `.github/workflows/` so that this
repository itself does not trigger pipeline runs.

## Layout

- `modules/tenant-network-baseline/` reusable Terraform module that creates
  a network, subnet, router, and security groups inside an existing tenant
- `environments/dev/` per-environment Terraform configuration that calls
  the module
- `examples/github-actions/terraform.yaml` example GitHub Actions workflow
  that runs `plan` on PRs and `apply` on merges to `main`

## Using this example

To adapt this for your own infrastructure repository:

1. Create a tenant in PCD with the cloud admin tooling. Note the tenant ID.
2. Identify the external network you want tenant routers to attach to.
   Note its ID with `pcdctl network list --external`.
3. Create a `clouds.yaml` with credentials scoped to your tenant. Application
   credentials are recommended over user passwords for pipeline use.
4. Copy `modules/tenant-network-baseline/` into your repo's `modules/`
   directory.
5. Copy `environments/dev/` into your repo and update `terraform.tfvars`
   with your real tenant ID and external network ID. Use
   `terraform.tfvars.example` as the template.
6. Copy `examples/github-actions/terraform.yaml` into your repo at
   `.github/workflows/terraform.yaml`.
7. Add a `CLOUDS_YAML` secret to your repository under
   Settings → Secrets and variables → Actions, containing the contents
   of your `clouds.yaml`.
8. Open a PR with the change. The `plan` job runs against the PR. After
   merge, the `apply-dev` job runs and creates the resources.

## State management caveat

This example uses Terraform's default local state backend, which means
the state file is created on the GitHub Actions runner during a pipeline
run and discarded when the runner exits. The first apply works because
Terraform creates resources from scratch. Subsequent applies will fail
because the runner has no record of what was created last time, and
Terraform will try to create resources that already exist.

Two ways to handle this:

1. Recreate from scratch each time you iterate. Delete the resources
   in PCD between pipeline runs (`pcdctl network delete`,
   `pcdctl router delete`, and so on). Acceptable for lab use;
   not acceptable for anything you care about.
2. Configure a remote state backend. Production use of this pattern
   requires a remote state backend with locking and encryption. This
   example does not include one because the right backend depends on
   your environment. See the Terraform documentation on backends:
   <https://developer.hashicorp.com/terraform/language/backend>

This caveat applies whether you're starting from an empty tenant or
adopting an existing one. The first commit may apply cleanly; the
second one will not without remote state.

## Scope

The example pipeline runs scoped to a single existing tenant. Tenant
provisioning is a separate cloud-admin workflow with different
authorization concerns; this repository does not address it.

## Related

- Blog series: Automating Private Cloud Director (link)
- Post 2: GitOps for tenant infrastructure with Terraform (link)