# Changelog — jeaw-agent-squad

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [2.2.0] — 2025-02-04

### Changed
- **AGENTS.MD consolidation** — All 8 rules merged into single AGENTS.MD file
  - Iron Laws repeated at START and END for LLM retention (based on "Lost in the Middle" paper)
  - File under 250 lines for better LLM context handling
  - Removed `.agent/rules/` directory (no longer needed)
- **Install scripts rewritten** — Now download from GitHub instead of hardcoded content
  - `install-agents.ps1` reduced from ~2200 lines to ~200 lines
  - `install-agents.sh` reduced from ~2800 lines to ~240 lines
  - Always gets latest version from repository
- **Daemon updated** — `loadRules()` → `loadAgentsMd()`, paths.rules → paths.agents_md
- **docs-writer skill** — Added README.md and ARCHITECTURE.md templates
- **developer skill** — Added 500 LOC per file rule
- **Code health tools** — Added jscpd + knip recommendations to AGENTS.MD

### Removed
- `.agent/rules/` directory (8 files consolidated into AGENTS.MD)
- `.claude/rules/` symlink (no longer needed)

---

## [2.1.0] — 2025-02-03

### Added
- **Code Reviewer** agent (`code-reviewer`) — Reviews PRs and code with technical rigor, guides how to receive feedback properly
- **Systematic Debugger** agent (`systematic-debugger`) — Debugging specialist following scientific method, finds root causes before proposing fixes
- 4 missing rules now included in install scripts:
  - `symlink-integrity.md` — Keeps .agent/ and .claude/ synchronized
  - `documentation-first.md` — Documentation as priority
  - `verification-before-completion.md` — Verify before claiming DONE
  - `mandatory-agent-activation.md` — Always read SKILL.md before acting

### Changed
- Team expanded from 11 to 13 agents
- Rules expanded from 4 to 8 in install scripts
- Updated all documentation (README, QUICKREF) to reflect new counts
- Updated transparency rule examples with new agents

---

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
