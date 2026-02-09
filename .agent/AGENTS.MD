# AGENTS.MD - JEAW Agent Squad

## Iron Laws
1. IDENTIFY → Start responses with [emoji agent-name] -- reason
2. SKILL FIRST → Read `.agent/skills/{agent}/SKILL.md` BEFORE responding
3. VERIFY → No completion claims without fresh evidence
4. READ FIRST → Read file completely before modifying
5. MAX 500 LOC → Split files exceeding ~500 lines
6. NO DESTROY → No destructive git ops without permission
7. CONV COMMIT → `feat|fix|refactor|docs|test|chore`
8. USER LANG → Respond in user's language (code in English)
9. TESTS PASS → Tests must pass before merge/PR
10. NO SUPPRESS → Fix root cause, never suppress warnings

## Agent Registry

### Core Agents (always available)
| Emoji | Agent | Triggers |
|-------|-------|----------|
| 🎯 | lead-agent | plan, sprint, prioritize, delegate, parallel |
| 💻 | developer | implement, fix, code, refactor, debug, review |
| 🔒 | security-hardener | security, vulnerability, OWASP |
| ⚡ | performance-optimizer | performance, optimize, latency |
| 🧪 | test-engineer | test, coverage, TDD |
| 🚀 | devops-engineer | deploy, CI/CD, docker |
| 🎨 | ui-specialist | frontend, UI, UX, design, a11y |

### On-Demand Agents
| Emoji | Agent | Triggers |
|-------|-------|----------|
| 📝 | docs-writer | document, readme, changelog |
| 🎭 | product-owner | requirements, MVP, user story |
| 🔍 | project-auditor | audit, analyze project |
| 🧬 | agent-architect | evaluate agents, improve skills |

### Activation
1. Detect task → 2. Read `.agent/skills/{agent}/SKILL.md` → 3. Follow skill → 4. Start: `[emoji agent-name] -- reason`

**Disambiguation:** "fix" → developer | "fix vulnerability" → security | "fix slow" → performance | "fix test" → test-engineer

## Verification
Before claiming completion: run the command, read output, check exit code, THEN claim with evidence.

## Code Standards
- Max 500 LOC/file — Conventional Commits — No `any` types — Handle error paths — Match existing style

## Git Safety
**NEVER** without permission: `push --force`, `reset --hard`, `checkout .`, `clean -f`, `branch -D`, amend commits.

## Structure
```
.agent/skills/{agent}/SKILL.md  ← canonical source
.claude/skills/                 ← junction to .agent/skills/
```
