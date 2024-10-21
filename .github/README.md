# More Than Certified GitOps MiniCamp 2024

The main purpose of this mini camp is to build a GitOps pipeline to deploy resources, managed by terraform to AWS using GitHub Actions.

[![semantic-release: conventionalcommits](https://img.shields.io/badge/semantic--release-conventionalcommits-blue?logo=semantic-release)](https://github.com/semantic-release/semantic-release) [![GitHub release](https://img.shields.io/github/release/3ware/gitops-2024?include_prereleases=&sort=semver&color=yellow)](https://github.com/3ware/workflows/gitops-2024/) [![issues - workflows](https://img.shields.io/github/issues/3ware/gitops-2024)](https://github.com/3ware/gitops-2024/issues) [![CI](https://img.shields.io/github/actions/workflow/status/3ware/gitops-2024/wait-for-checks.yaml?label=CI&logo=githubactions&logoColor=white)](https://github.com/3ware/workflows/actions/gitops-2024/wait-for-checks.yaml)

## Table of contents

<details>
  <summary>Table of contents</summary>
  <br>

- [More Than Certified GitOps MiniCamp 2024](#more-than-certified-gitops-minicamp-2024)
  - [Table of contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Workflow](#workflow)
    - [When to apply?](#when-to-apply)
    - [Directories vs Workspaces for multiple environments](#directories-vs-workspaces-for-multiple-environments)
    - [Branching Strategy](#branching-strategy)
    - [Diagram](#diagram)
    - [Workflows](#workflows)
      - [Infracost](#infracost)
      - [Terraform CI](#terraform-ci)
        - [Validate](#validate)
        - [Plan](#plan)
        - [Apply](#apply)
        - [Diff Check](#diff-check)
      - [Terraform Docs](#terraform-docs)
      - [Release](#release)
  - [To do list](#to-do-list)

</details>

## Requirements

<details>
  <summary>Expand to see requirements</summary>
  <br>

| **Section**             | **Task**                                  | **Self-Reported Status** | **Notes**                                                  |
| :---------------------- | :---------------------------------------- | :----------------------: | :--------------------------------------------------------- |
| **Setup**               |                                           |                          |                                                            |
|                         | Main branch is protected                  |    :white_check_mark:    |                                                            |
|                         | Cannot merge to main with failed checks   |    :white_check_mark:    |                                                            |
|                         | State is stored remotely                  |    :white_check_mark:    |                                                            |
|                         | State Locking mechanism is enabled        |    :white_check_mark:    |                                                            |
| **Design and Code**     |                                           |                          |                                                            |
|                         | Confirm Account Number                    |    :white_check_mark:    | data source post condition                                 |
|                         | Confirm Region                            |    :white_check_mark:    | variable validation                                        |
|                         | Add Default Tags                          |    :white_check_mark:    | added to provider block                                    |
|                         | Avoid Hardcoded Values                    |    :white_check_mark:    |                                                            |
|                         | No plaintext credentials                  |    :white_check_mark:    | Environment variables set by OIDC                          |
|                         | Pipeline in GitHub Actions only           |    :white_check_mark:    |                                                            |
| **Validate**            |                                           |                          |                                                            |
|                         | terraform fmt pre-commit hook             |    :white_check_mark:    | Git Hooks managed by trunk-io                              |
|                         | pre-commit hooks are in repo              |    :white_check_mark:    | Git Hooks managed by trunk-io                              |
| **Test and Review**     |                                           |                          |                                                            |
|                         | Pipeline works on every PR                |    :white_check_mark:    | `on: pull_request trigger`                                 |
|                         | Linter                                    |    :white_check_mark:    | TFLint configured with aws plugin and deep check           |
|                         | terraform fmt                             |    :white_check_mark:    | See PR https://github.com/3ware/gitops-2024/pull/5         |
|                         | terraform validate                        |    :white_check_mark:    | See PR https://github.com/3ware/gitops-2024/pull/5         |
|                         | terraform plan                            |    :white_check_mark:    | See PR https://github.com/3ware/gitops-2024/pull/5         |
|                         | Infracost with comment                    |    :white_check_mark:    | See PR https://github.com/3ware/gitops-2024/pull/4         |
|                         | Open Policy Agent fail if cost > $10      |    :white_check_mark:    | See PR https://github.com/3ware/gitops-2024/pull/6         |
| **Deploy**              |                                           |                          |                                                            |
|                         | terraform apply with human intervention   |    :white_check_mark:    | Applied when PR is approved                                |
|                         | Deploy to production environment          |                          | Currently deploying to _development_ environment           |
| **Operate and Monitor** |                                           |                          |                                                            |
|                         | Scheduled drift detection                 |                          |                                                            |
|                         | Scheduled port accessibility check        |                          |                                                            |
| **Readme**              |                                           |                          |                                                            |
|                         | Organized Structure                       |    :white_check_mark:    |                                                            |
|                         | Explains all workflows                    |    :white_check_mark:    |                                                            |
|                         | Link to docs for each action              |    :white_check_mark:    |                                                            |
|                         | Contribution Instructions                 |                          |                                                            |
|                         | Explains merging strategy                 |    :white_check_mark:    |                                                            |
| **Bonus**               |                                           |                          |                                                            |
|                         | Deploy to multiple environments           |                          |                                                            |
|                         | Ignore non-terraform changes              |    :white_check_mark:    | Workflow trigger use paths filter for tf and tfvars files. |
|                         | Comment PR with useful plan information   |    :white_check_mark:    | See PR https://github.com/3ware/gitops-2024/pull/7         |
|                         | Comment PR with useful Linter information |    :white_check_mark:    | See PR https://github.com/3ware/gitops-2024/pull/5         |
|                         | Open an Issue if Drifted                  |                          |                                                            |
|                         | Open an issue if port is inaccessible     |                          |                                                            |
|                         | Comment on PR to apply                    |    :white_check_mark:    | PR is approved to apply                                    |

</details>

## Workflow

- Create feature branch off main
- Commit change locally and push to remote
- Create a draft pull request that targets the main branch: `gh pr create --draft --base main`

> [!IMPORTANT]
> Pull Request must be set to draft to prevent CODEOWNER reviewers being assigned until the pull request is ready.
> This cannot be set by default. See [open discussion](https://github.com/orgs/community/discussions/6943).
> Unfortunately this also cannot be automated because action runners, using `GITHUB_TOKEN` for authentication, are unable to run `gh pr ready --undo` as the integration is unavailable. See [open discussion](https://github.com/cli/cli/issues/8910)

- When the [Workflows](#workflows) have completed, mark the PR as ready to assign a reviewer from CODEOWNERS. (again cannot be automated on a runner)
- If the PR is approved, the workflow will run again to apply the changed.

### When to apply?

The [debate rumbles on](https://terramate.io/rethinking-iac/mastering-terraform-workflows-apply-before-merge-vs-apply-after-merge/). In this case, because it's just me, apply before merge is fine.

### Directories vs Workspaces for multiple environments

Another debate. The best argument I have heard for directories was in the Q&A session on 19/10/2024:

> _"anyone should be able to `cd` into a terraform working directory and simply run `terraform plan` without have to worry about workspaces and variable files"_

The workflow currently runs in the _development_ directory, with a view to having a _production_ directory should time allow.

### Branching Strategy

```mermaid
---
config:
  theme: base
---
gitGraph
  commit id: "prev" tag: "v1.0.0"
  branch feature
  switch feature
  commit id: "Terraform Changes"
  commit id: "Bug Fix"
  commit id: "Plan Diff fix"
  switch main
  merge feature
  commit id: "new" tag: "v1.1.0"
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
    Merge PR`")
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
    devplan(terraform plan)-->AP{"`**Approve Plan**
    via PR approval`"} -->|No|F
    AP -->|Yes|devapply(terraform apply) -->testdev("`**Diff Check**
    terraform plan -detailed-exitcode`") -->E{Exit code} -->|2 - Diff|PRC(PR Comment)
  end
  PR(Draft Pull Request) --> Test
  validate -->|Pass|devplan
  E{Exit code} -->|0 - Succeeded|P
  PRC -->F
  F -->|Make changes and resubmit|Test
```

### Workflows

#### Infracost

[Infracost](workflows/infracost.yaml) runs on pull requests when they are opened or synchronized. The workflow generates a cost difference of the resources between the main branch and the proposed changes on the feature branch.

This workflow also flags any policy violations defined in [infracost-policy.rego](../infracost/infracost-policy.rego). See an example in this [pull_request](https://github.com/3ware/gitops-2024/pull/6)

#### Terraform CI

##### Validate

- Setup AWS credentials using [config-aws-credentials](https://github.com/aws-actions/configure-aws-credentials) using OIDC to assume a role and set the authentication parameters as environment variables on the runner. This step is required when TFLint [deep checking](https://github.com/terraform-linters/tflint-ruleset-aws/blob/master/docs/deep_checking.md) for the AWS rule plugin is enabled.
- ~~Setup terraform using [setup-terraform](https://github.com/hashicorp/setup-terraform)~~ Not required. terraform v1.9.7 already installed on runner image.

> [!NOTE]
> This may not be required because terraform 1.9.7 is installed on the [runner image](https://github.com/actions/runner-images/blob/ubuntu22/20241015.1/images/ubuntu/Ubuntu2204-Readme.md)

- Run `terraform fmt`
- Run `terraform init`
- Run `terraform validate`
- Install TFLint using [setup-tflint](https://github.com/terraform-linters/setup-tflint)
- Initialise TFLint to download the AWS plugin rules
- Run `tflint`
- Run [trunk code quality action](https://github.com/marketplace/actions/trunk-check); this runs checkov and trivy security checks
- Update the PR comments if any of the steps fails and exit the workflow on failure

##### Plan

When a draft pull request is opened, and the Test Terraform job has succeeded - a ` terraform plan` will be run.
The workflow uses [TF-via-PR](https://github.com/DevSecTop/TF-via-PR). This action adds a high level plan and detailed drop down style plan to the workflow summary and updates the pull request with a comment.

##### Apply

After `terraform plan` has been run, assuming the plan is satisfactory, mark the pull request ready for review. Assuming the pull request is approved, the workflow will run again - this time running `terraform apply`, with `plan_parity` set, to ensure the plan has not changed.

##### Diff Check

Following a successful apply, another plan is run to check for any diffs. If a diff is detected a pull request comment is added and the workflow exits with a failure. If a diff is not detected, the pull request can be merged.

#### Terraform Docs

[Terraform docs](https://github.com/terraform-docs/gh-actions) will run when the pull request is merged. This only needs to run once, following the apply, and not on every commit to a pull request. Updating the README on every commit generates a lot unnecessary commits and you have to pull the updated README prior to the next push to avoid conflicts.

I use my own [Terraform Docs reusable workflow](https://github.com/3ware/workflows/blob/main/.github/workflows/terraform-docs.yaml) which adds job summaries and verified commits.

#### Release

Generate a CHANGELOG and version tag using [semantic release](https://github.com/cycjimmy/semantic-release-action)

## To do list

- [ ] Drift check
- [ ] Grafana Port Check
- [ ] Test without setup terraform action because it's already installed on the runner
- [ ] Test plan parity and drift detection
- [ ] Pull request labels for : approval-required, approved, environment
- [ ] Job matrix for multiple environments
- [ ] Conditional execution, if possible and not too complicated, or the plan-and-apply job
