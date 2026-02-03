# Convergence Architecture Rule

## Overview

This project may use the Convergence Architecture for multi-agent coordination:
- **Beads (bd):** Git-backed task tracker (single source of truth for task state)
- **Git Worktrees:** Physical isolation for parallel agent execution
- **gemini-mcp:** Gemini as context oracle (1M token window) for Claude Code
- **antigravity-claude-proxy:** Unifies Claude Max + Gemini Pro subscriptions
- **Vibe Kanban:** Visual dashboard for task progress

## Detection

Check if convergence infrastructure is active:
- Beads: `[ -d ".beads" ] && command -v bd && echo "ACTIVE"`
- Worktrees: `git worktree list`
- gemini-mcp: `claude mcp list | grep -i gemini`

## Beads Workflow (When Active)

Beads uses polling, not push notifications.

Planning agents (tech-lead, orchestrator): `bd create`, `bd list --format json`
Execution agents (developer, security, etc.): `bd ready --json` > `bd update <id> --status in_progress` > work > `bd close <id>` > `bd sync`
Audit agents (auditor, architect): `bd list --assignee <agent> --status closed --format json`

## Git Worktrees (When Active)

Create: `git worktree add .trees/<wave>-<role> feature/<branch>`
Work in isolation. Never modify files outside assigned worktree.
Merge: `git merge feature/<branch>` then `git worktree remove .trees/<wave>-<role>`

## Model Specialization

Claude (Claude Code CLI): Execution agents (developer, security, perf, tester, devops)
Gemini (Antigravity/CLI): Planning + audit agents (auditor, tech-lead, orchestrator, architect, a11y)

## Backward Compatibility

All convergence features are optional. If Beads is not initialized, Worktrees not used, or only one model available, agents fall back to standard behavior.

## Do NOT

- Do not mention convergence architecture unless relevant
- Do not auto-initialize Beads without user approval
- Do not create worktrees unless orchestrator requests parallel execution
- Do not assume Gemini is available -- always check