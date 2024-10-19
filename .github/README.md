# More Than Certified GitOps MiniCamp 2024

The main purpose of this mini camp is to build a GitOps pipeline to deploy resources, managed by terraform to AWS using GitHub Actions.

[![semantic-release: conventionalcommits](https://img.shields.io/badge/semantic--release-conventionalcommits-blue?logo=semantic-release)](https://github.com/semantic-release/semantic-release) [![GitHub release](https://img.shields.io/github/release/3ware/gitops-2024?include_prereleases=&sort=semver&color=yellow)](https://github.com/3ware/workflows/gitops-2024/) [![issues - workflows](https://img.shields.io/github/issues/3ware/gitops-2024)](https://github.com/3ware/gitops-2024/issues) [![CI](https://img.shields.io/github/actions/workflow/status/3ware/gitops-2024/wait-for-checks.yaml?label=CI&logo=githubactions&logoColor=white)](https://github.com/3ware/workflows/actions/gitops-2024/wait-for-checks.yaml)

## Table of contents

- [Requirements](#requirements)
- [Workflow](#workflow)
  - [Branching Strategy](#branching-strategy)
  - [Diagram](#diagram)
  - [Terraform](#terraform)

## Requirements

| **Section**             | **Task**                                  | **Self-Reported Status** | **Notes**                                                                                    |
| ----------------------- | ----------------------------------------- | ------------------------ | -------------------------------------------------------------------------------------------- |
| **Setup**               |                                           |                          |                                                                                              |
|                         | Main branch is protected                  | :white_check_mark:       |                                                                                              |
|                         | Cannot merge to main with failed checks   | :white_check_mark:       |                                                                                              |
|                         | State is stored remotely                  | :white_check_mark:       |                                                                                              |
|                         | State Locking mechanism is enabled        | :white_check_mark:       |                                                                                              |
| **Design and Code**     |                                           |                          |                                                                                              |
|                         | Confirm Account Number                    | :white_check_mark:       | data source post condition                                                                   |
|                         | Confirm Region                            | :white_check_mark:       | variable validation                                                                          |
|                         | Add Default Tags                          | :white_check_mark:       | added to provider block                                                                      |
|                         | Avoid Hardcoded Values                    | :white_check_mark:       |                                                                                              |
|                         | No plaintext credentials                  | :white_check_mark:       | Environment variables set by OIDC                                                            |
|                         | Pipeline in GitHub Actions only           | :white_check_mark:       |                                                                                              |
| **Validate**            |                                           |                          |                                                                                              |
|                         | terraform fmt pre-commit hook             | :white_check_mark:       | Git Hooks managed by [trunk-io](https://docs.trunk.io/cli/getting-started/actions/git-hooks) |
|                         | pre-commit hooks are in repo              | :white_check_mark:       |                                                                                              |
| **Test and Review**     |                                           |                          |                                                                                              |
|                         | Pipeline works on every PR                | :white_check_mark:       | `on: pull_request trigger`                                                                   |
|                         | Linter                                    | :white_check_mark:       | TFLint configured with aws plugin and deep check                                             |
|                         | terraform fmt                             | :white_check_mark:       | https://github.com/3ware/gitops-2024/pull/5                                                  |
|                         | terraform validate                        | :white_check_mark:       | https://github.com/3ware/gitops-2024/pull/5                                                  |
|                         | terraform plan                            | :white_check_mark:       | https://github.com/3ware/gitops-2024/pull/5                                                  |
|                         | Infracost with comment                    | :white_check_mark:       | https://github.com/3ware/gitops-2024/pull/4                                                  |
|                         | Open Policy Agent fail if cost > $10      | :white_check_mark:       | https://github.com/3ware/gitops-2024/pull/6                                                  |
| **Deploy**              |                                           |                          |                                                                                              |
|                         | terraform apply with human intervention   |                          |                                                                                              |
|                         | Deploy to production environment          |                          |                                                                                              |
| **Operate and Monitor** |                                           |                          |                                                                                              |
|                         | Scheduled drift detection                 |                          |                                                                                              |
|                         | Scheduled port accessibility check        |                          |                                                                                              |
| **Readme**              |                                           |                          |                                                                                              |
|                         | Organized Structure                       |                          |                                                                                              |
|                         | Explains all workflows                    |                          |                                                                                              |
|                         | Link to docs for each action              |                          |                                                                                              |
|                         | Contribution Instructions                 |                          |                                                                                              |
|                         | Explains merging strategy                 |                          |                                                                                              |
| **Bonus**               |                                           |                          |                                                                                              |
|                         | Deploy to multiple environments           |                          |                                                                                              |
|                         | Ignore non-terraform changes              | :white_check_mark:       | Workflow trigger use paths filter for tf and tfvars files.                                   |
|                         | Comment PR with useful plan information   | :white_check_mark:       | https://github.com/3ware/gitops-2024/pull/7                                                  |
|                         | Comment PR with useful Linter information | :white_check_mark:       | https://github.com/3ware/gitops-2024/pull/5                                                  |
|                         | Open an Issue if Drifted                  |                          |                                                                                              |
|                         | Open an issue if port is inaccessible     |                          |                                                                                              |
|                         | Comment on PR to apply                    |                          |                                                                                              |

## Workflow

### Branching Strategy

Create feature branch
Commit and push changes
Create a draft pull request - annoying that this cannot be set as the default.

TBC. Currently, feature branch of main.

```mermaid
---
config:
  theme: base
---
gitGraph
  commit
  commit
  branch feature
  commit
  commit
```

### Diagram

```mermaid
---
config:
  look: handDrawn
  theme: neo
---
flowchart LR
  subgraph Fail
    direction LR
    F("`**Fail Required Checks**
    PR Cannot be merged`")
  end
  subgraph Pass
    direction LR
    P("`**Met Required Checks**
    Merge PR & Apply to Prod`")
  end
  subgraph Test
    direction LR
    setup("`**Setup**
    AWS Credentials
    Install and Initialise tofu
    Install and Initialise TFLint
    with AWS Plugin`") -->
    validate{"`**Validate**
    terraform fmt
    terraform validate
    tflint
    Infracost fail if > $10`"} -->|Fail|F
  end
  subgraph Development [Deploy Development Environment]
    direction LR
    dapply(terraform apply -auto-approve)-->test
    test("`Test Deployment
    terraform plan -detailed-exitcode`") -->E{Exit code} -->|2 - Diff|I(Issue)
    I -->F
  end
  subgraph Production [Deploy Production Environment]
    direction LR
    pplan(terraform plan) -->approve{Approve plan}
  end
  PR --> Test
  validate -->|Pass|dapply
  E{Exit code} -->|0 - Succeeded|pplan
  approve{Approve plan} -->|No|F
  approve{Approve plan} -->|Yes|P
```

### Terraform
