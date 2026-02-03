# Symlink Integrity Rule

## Purpose

Ensure that `.agent/` (the canonical source) and `.claude/` (the symlink) are always synchronized. This prevents confusion when skills or rules exist in one location but not the other.

## Architecture

```
.agent/                    ← CANONICAL SOURCE (edit here)
├── rules/
│   ├── transparency.md
│   ├── mandatory-agent-activation.md
│   ├── symlink-integrity.md
│   ├── documentation-first.md
│   ├── onboarding.md
│   ├── periodic-evaluation.md
│   └── convergence-architecture.md
└── skills/
    ├── project-auditor/SKILL.md
    ├── tech-lead/SKILL.md
    ├── developer/SKILL.md
    └── ... (11 agents)

.claude/                   ← SYMLINK (auto-synced)
├── rules/ → ../.agent/rules/
└── skills/ → ../.agent/skills/
```

## Rules

### 1. Always Edit in `.agent/`

**NEVER edit files in `.claude/` directly.**

The `.claude/` directory contains symlinks pointing to `.agent/`. Editing the canonical source (`.agent/`) automatically updates all symlinked locations.

### 2. Verify Symlinks on Session Start

When starting work on a project, verify symlinks are intact:

**Windows (PowerShell):**
```powershell
# Check if symlinks exist and point correctly
(Get-Item .claude\rules).Target
(Get-Item .claude\skills).Target
```

**Linux/macOS:**
```bash
ls -la .claude/
# Should show: rules -> ../.agent/rules
# Should show: skills -> ../.agent/skills
```

### 3. Repair Broken Symlinks

If symlinks are broken or missing:

**Windows (Admin PowerShell):**
```powershell
# Remove broken symlinks
Remove-Item .claude\rules -Force -ErrorAction SilentlyContinue
Remove-Item .claude\skills -Force -ErrorAction SilentlyContinue

# Recreate symlinks
New-Item -ItemType SymbolicLink -Path .claude\rules -Target ..\.agent\rules
New-Item -ItemType SymbolicLink -Path .claude\skills -Target ..\.agent\skills
```

**Linux/macOS:**
```bash
rm -f .claude/rules .claude/skills
ln -s ../.agent/rules .claude/rules
ln -s ../.agent/skills .claude/skills
```

### 4. Multi-Tool Symlinks

If using multiple AI tools, all should symlink to `.agent/`:

| Tool | Symlink Path | Target |
|------|--------------|--------|
| Claude Code | `.claude/skills/` | `../.agent/skills/` |
| Antigravity | `.gemini/skills/` | `../.agent/skills/` |
| Cursor | `.cursor/skills/` | `../.agent/skills/` |
| Codex | `.codex/skills/` | `../.agent/skills/` |

### 5. Git Handling

Symlinks should be committed to git. Verify `.gitattributes` includes:

```
# Treat symlinks as symlinks (not as text files)
* text=auto
.claude/** -text
```

## Detection Checklist

Before any agent work, verify:

- [ ] `.agent/` directory exists
- [ ] `.agent/skills/` contains SKILL.md files
- [ ] `.agent/rules/` contains rule files
- [ ] `.claude/` exists (if using Claude Code)
- [ ] `.claude/skills` is a symlink pointing to `../.agent/skills`
- [ ] `.claude/rules` is a symlink pointing to `../.agent/rules`

## Error Messages

If symlinks are broken, inform the user:

```
⚠️ Symlink integrity check failed.

.claude/skills is not properly linked to .agent/skills

To fix (run as admin on Windows):
  Remove-Item .claude\skills -Force
  New-Item -ItemType SymbolicLink -Path .claude\skills -Target ..\.agent\skills

Or re-run the installer:
  powershell -ExecutionPolicy Bypass -File C:\www\agentes\install-agents.ps1
```

## Why This Matters

1. **Single Source of Truth**: All tools read from the same skills
2. **No Drift**: Changes in one place propagate everywhere
3. **Simpler Updates**: Update `.agent/`, everything updates
4. **Cross-Tool Consistency**: Claude, Gemini, Cursor all behave the same
5. **Git Cleanliness**: No duplicate files, smaller commits
