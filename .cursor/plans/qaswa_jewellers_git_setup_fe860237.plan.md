---
name: Qaswa Jewellers Git Setup
overview: Initialize the `qaswa_jewellers` Flutter project as a private GitHub repo with git flow branches, and automate code review + PR creation via a Cursor Rule and shell scripts.
todos:
  - id: gitignore
    content: Create Flutter .gitignore
    status: completed
  - id: git-init
    content: Initialize git, make initial commit, create GitHub repo, push main
    status: in_progress
  - id: dev-branch
    content: Create and push dev branch
    status: pending
  - id: cursor-rule
    content: Create .cursor/rules/git-flow.mdc with PR review workflow
    status: completed
  - id: pr-script
    content: Create .cursor/scripts/pr-review.sh and make executable
    status: in_progress
isProject: false
---

# Qaswa Jewellers Git Flow Setup

## What will be set up

- Private GitHub repo `qaswa_jewellers` with `main` and `dev` branches
- A Flutter `.gitignore` to exclude build artifacts
- A Cursor Rule (`.cursor/rules/git-flow.mdc`) that permanently encodes the PR workflow — so whenever you say "review my PR" or "create a PR", I automatically know the exact steps to take
- A reusable shell script (`.cursor/scripts/pr-review.sh`) that diffs the current branch against `dev` and formats output for review

## Git Flow Diagram

```mermaid
gitGraph
   commit id: "Initial commit"
   branch dev
   checkout dev
   commit id: "dev branch"
   branch feature/your-feature
   checkout feature/your-feature
   commit id: "feature work"
   checkout dev
   merge feature/your-feature id: "PR merged"
   checkout main
   merge dev id: "release"
```

## Automated PR Workflow (triggered by "review my PR")

```mermaid
flowchart TD
    A["User: review my PR"] --> B["Detect current branch"]
    B --> C["git diff dev...HEAD"]
    C --> D["AI code review"]
    D --> E["List issues found"]
    E --> F{Issues acceptable?}
    F -->|"Yes / User approves"| G["gh pr create --base dev"]
    F -->|"No"| H["Fix issues, repeat"]
```

## Files to create

- `.gitignore` — standard Flutter gitignore (excludes `build/`, `.dart_tool/`, etc.)
- `.cursor/rules/git-flow.mdc` — always-apply rule encoding the review+PR workflow
- `.cursor/scripts/pr-review.sh` — script that runs `git diff dev...HEAD` and surfaces stats/files changed for review context

## Step-by-step execution

1. Add `.gitignore` (Flutter template)
2. `git init && git add . && git commit -m "Initial commit"`
3. `gh repo create qaswa_jewellers --private --source=. --remote=origin --push` — creates the GitHub repo and pushes `main`
4. `git checkout -b dev && git push -u origin dev` — create and push `dev` branch
5. Create `.cursor/rules/git-flow.mdc` with the PR review workflow instructions
6. Create `.cursor/scripts/pr-review.sh` and make it executable

## The Cursor Rule (what gets automated)

The rule will instruct me to — whenever you say "review my PR":
1. Run `git branch --show-current` to confirm the feature branch
2. Run `.cursor/scripts/pr-review.sh` to get the full diff vs `dev`
3. Perform a structured review (architecture, logic, style, tests)
4. Output a numbered issue list
5. Wait for your go-ahead, then run `gh pr create --base dev --title "..." --body "..."`

## Prerequisites needed on your machine

- `gh` CLI installed and authenticated (`gh auth login`) — needed for repo creation and PR creation
- `git` installed (you have it)
