# Changelog — jeaw-agent-squad

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [2.0.0] — 2025-02-03

### Added
- **Convergence Architecture** integration across all agents
  - Beads (bd) task lifecycle in all execution agents
  - Beads Integration section in tech-lead for sprint registration
  - Beads + Git Worktrees state management in orchestrator
  - Beads Analytics in agent-architect for data-driven evaluation
  - Model specialization matrix (Claude → execution, Gemini → planning/audit)
- New rule: `convergence-architecture.md` — defines multi-agent infrastructure
- Onboarding rule now suggests Beads initialization on new projects
- Remote install support: `curl | bash` one-liner with `--option` flag
- `update.sh` script for pulling latest version and re-installing
- VERSION file for tracking installed version

### Changed
- Orchestrator state management rewritten: Beads + Worktrees replace dispatch-state.md (with fallback)
- All agent SKILL.md files now include backward-compatible convergence sections
- Install summary now shows convergence architecture setup instructions

## [1.0.0] — 2025-01-28

### Added
- Initial release with 11 agents
- Project Auditor (8-phase deep audit)
- Tech Lead (sprint planning, delegation)
- Developer (full-stack implementation)
- Security Hardener (OWASP, input validation, headers)
- Performance Optimizer (queries, caching, bundle size)
- Test Engineer (unit, integration, e2e)
- Docs Writer (sprint logs, journal, README, ADRs)
- DevOps Engineer (CI/CD, Docker, dev observability)
- Accessibility Auditor (WCAG 2.1 AA)
- Agent Architect (meta-agent, evaluation, skill management)
- Orchestrator (parallel dispatch with waves)
- 3 behavior rules: transparency, onboarding, periodic evaluation
- Symlink-based sync between tool directories
- External repo management (Superpowers, Awesome Skills)
- Windows (PowerShell) and Linux/macOS (Bash) installers
