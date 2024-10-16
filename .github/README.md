# More Than Certified GitOps MiniCamp 2024

The main purpose of this mini camp is to build a GitOps pipeline to deploy resources, managed by terraform to AWS using GitHub Actions.

[![semantic-release: conventionalcommits](https://img.shields.io/badge/semantic--release-conventionalcommits-blue?logo=semantic-release)](https://github.com/semantic-release/semantic-release) [![GitHub release](https://img.shields.io/github/release/3ware/gitops-2024?include_prereleases=&sort=semver&color=yellow)](https://github.com/3ware/workflows/gitops-2024/) [![issues - workflows](https://img.shields.io/github/issues/3ware/gitops-2024)](https://github.com/3ware/gitops-2024/issues) [![CI](https://img.shields.io/github/actions/workflow/status/3ware/gitops-2024/wait-for-checks.yaml?label=CI&logo=githubactions&logoColor=white)](https://github.com/3ware/workflows/actions/gitops-2024/wait-for-checks.yaml)

## Table of contents

- [Requirements](#requirements)
- [Workflow](#workflow)
  - [Branching Strategy](#branching-strategy)
  - [Diagram](#diagram)
  - [Infracost](#infracost)
  - [Terraform](#terraform)

## Requirements

## Workflow

### Branching Strategy

TBC. Currently, feature branch of main.

<!-- ```mermaid
title: Branching Strategy
gitGraph
commit
```
-->

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
    P("`**Pass Required Checks**
    PR Can be merged`")
  end
  subgraph Infracost
    direction LR
    ic{"`**Infracost**
    Fail if > $10`"}
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
    tflint`"} -->|Fail|F
  end
  subgraph Deploy [Deploy Development Environment]
    plan(terraform plan) -->
    approve{Approve plan} -->|Yes|Y(terraform apply)-->test
    approve -->|No|F
    test("`Test Deployment
    terraform plan -detailed-exitcode`") -->E{Exit code} -->|0 - Succeeded|P
    E -->|1 - Errored|I(Issue)
    E -->|2 - Diff|I(Issue)
    I -->F
  end
  PR --> ic
  PR --> Test
  validate -->|Pass|plan
  ic -->|Over Budget|F
  ic -->|Within Budget|P
```

### Infracost

### Terraform
