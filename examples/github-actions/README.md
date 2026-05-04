# Example GitHub Actions workflow

`terraform.yaml` is the example pipeline workflow described in Post 2 of
the Automating PCD CI/CD blog series.

## Why this lives here

GitHub Actions registers any `.yaml` or `.yml` file under
`.github/workflows/` as an active workflow. Storing the file there in
this repository would cause it to run against the example Terraform code
on every push and pull request, which is not the intent. Keeping the
file under `examples/github-actions/` lets it serve as documentation
without executing.

## To use

Copy `terraform.yaml` to `.github/workflows/terraform.yaml` in your
own infrastructure repository. Add a `CLOUDS_YAML` secret to that
repository with credentials scoped to your target tenant.

The workflow runs:

- `plan` on every pull request that touches `environments/**` or
  `modules/**`
- `apply-dev` on every push to `main` that touches the same paths
- Manually via `workflow_dispatch` for diagnostic runs (the apply jobs
  still skip unless triggered by a real push to `main`)
