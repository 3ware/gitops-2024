# More Than Certified GitOps MiniCamp 2024

The main purpose of this mini camp is to build a GitOps pipeline to deploy resources, managed by terraform / OpenTofu to AWS using GitHub Actions.

## Requirements

See rubric document

## Design

### Branching Strategy

TBC. Currently, feature branch of main.

<!-- ```mermaid
title: Branching Strategy
gitGraph
commit
```
-->

### Pipeline Diagram

First pass at a diagram documenting the flow of the pipeline

```mermaid
flowchart LR
  subgraph Test
    direction LR
    setup("`**Setup**
    AWS Credentials
    Install and Initialise tofu
    Install and Initialise TFLint
    with AWS Plugin`") -->
    validate{"`**Validate**
    tofu fmt
    tofu validate
    tflint
    infracost`"} -->|Fail|I(Issue)
  end
  subgraph Deploy [Deploy Development Environment]
    plan(tofu plan) -->
    approve{Approve plan} -->|Yes|Y(tofu apply)-->test
    approve -->|No|H(End)
    test("`Test Deployment
    tofu plan -detailed-exitcode`") -->E{Exit code} -->|0 - Succeeded|G(Clean Up) -->|tofu destroy|H(End)
    E -->|1 - Errored|I(Issue)
    E -->|2 - Diff|I(Issue)
    I -->H

  end
  PR --> Test
  validate -->|Pass|plan

```
