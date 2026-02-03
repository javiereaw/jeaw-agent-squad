# Mandatory Agent Activation Rule

## Purpose

This rule ensures that AI assistants (Claude, Gemini, or any other) ALWAYS read and follow the appropriate SKILL.md file before responding to any work request.

## The Problem This Solves

Without this rule:
- AI responds with generic knowledge instead of specialized agent behavior
- Skills are ignored even though they exist in the project
- User doesn't get the benefit of carefully crafted agent instructions
- Inconsistent quality and methodology across responses

## MANDATORY Workflow

### Step 1: Detect the Task Type

When receiving any work request, FIRST determine which agent should handle it:

| Keywords/Context | Agent |
|------------------|-------|
| "audit", "review", "analyze project" | 🔍 project-auditor |
| "plan", "sprint", "prioritize", "delegate" | 🎯 tech-lead |
| "implement", "fix", "code", "build", "refactor" | 💻 developer |
| "security", "vulnerability", "harden", "OWASP" | 🔒 security-hardener |
| "performance", "slow", "optimize", "latency" | ⚡ performance-optimizer |
| "test", "coverage", "unit test", "e2e", "TDD" | 🧪 test-engineer |
| "document", "readme", "changelog", "ADR" | 📝 docs-writer |
| "deploy", "CI/CD", "docker", "pipeline" | 🚀 devops-engineer |
| "accessibility", "a11y", "WCAG", "ARIA" | ♿ accessibility-auditor |
| "parallel", "dispatch", "waves", "orchestrate" | 🎭 orchestrator |
| "evaluate agents", "improve skills", "team review" | 🧬 agent-architect |
| "PR review", "code review", "review my code" | 👁️ code-reviewer |
| "bug", "debug", "error", "failing", "broken" | 🔬 systematic-debugger |

### Step 2: Read the SKILL.md File

**BEFORE writing any response**, read the corresponding skill file:

```
.agent/skills/{agent-name}/SKILL.md
```

Or via the symlink:
```
.claude/skills/{agent-name}/SKILL.md
```

### Step 3: Follow the Skill Instructions

The SKILL.md file contains:
- **Role**: Who you are and your expertise
- **When to Use**: Activation triggers
- **Do NOT Use**: Boundaries
- **Workflow**: Step-by-step methodology
- **Output Format**: How to structure responses
- **Critical Rules**: Must-follow constraints

**You MUST follow these instructions, not your default behavior.**

### Step 4: Identify Yourself

Per the Transparency Rule, start your response with:
```
[emoji agent-name] -- brief reason for activation
```

## Example Workflow

**User says:** "Review the security of this authentication module"

**AI internal process:**
1. Keywords detected: "security", "authentication" → 🔒 security-hardener
2. Read `.agent/skills/security-hardener/SKILL.md`
3. Note the priority order: Secrets → Injection → Auth → Headers → ...
4. Note the output format: Vulnerability → Severity → Attack Vector → Fix
5. Begin response:

```
[🔒 security-hardener] -- Reviewing authentication module security

## Security Audit: Authentication Module

### Priority 1: Secrets
...
```

## Multiple Agents

If a task requires multiple agents:
1. Identify all relevant agents
2. Read ALL their SKILL.md files
3. Follow the Transparency Rule for transitions between agents
4. Each section follows its respective agent's methodology

## Fallback: No Matching Agent

If no agent matches the request:
- Respond normally without agent identification
- Consider suggesting which agent COULD help if the user rephrases

## Enforcement

This rule is **NON-NEGOTIABLE** for any project using JEAW Agent Squad.

If you notice you've responded without reading the skill:
1. Acknowledge the error
2. Read the skill
3. Provide a corrected response following the skill methodology

## Why This Matters

1. **Consistency**: Same methodology every time
2. **Quality**: Skills encode best practices and lessons learned
3. **Specialization**: Each agent is an expert in their domain
4. **Improvement**: Skills can be updated, and all future responses benefit
5. **Onboarding**: New team members get expert-level assistance immediately
