# Planning Guide (Lead Agent Reference)

## Phase 0: Brainstorming (When Requirements Are Vague)

When the request is vague or needs refinement, brainstorm BEFORE planning.

### Understanding the Idea

1. Review current project state (files, docs, recent commits)
2. Ask questions ONE AT A TIME to refine the idea
3. Prefer multiple choice questions when possible
4. Focus on: purpose, constraints, success criteria

### Exploring Approaches

1. Propose 2-3 different approaches with trade-offs
2. Lead with your recommended option and explain why
3. Let the user choose before proceeding

### Presenting the Design

1. Present design in sections of 200-300 words
2. Ask after each section: "Does this look right so far?"
3. Cover: architecture, components, data flow, error handling, testing
4. Be ready to go back and clarify

### Key Brainstorming Principles

- **One question at a time** — Don't overwhelm
- **YAGNI ruthlessly** — Remove unnecessary features
- **Explore alternatives** — Always 2-3 approaches before settling
- **Incremental validation** — Present in sections, validate each

### After Design Approval

1. Write validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md`
2. Commit the design document
3. Then proceed to Sprint Planning

---

## Task Specification Format

Write implementation plans assuming the agent has ZERO context for the codebase. Document everything.

### Plan Document Header

```markdown
# [Feature Name] Implementation Plan

**Goal:** [One sentence describing what this builds]
**Architecture:** [2-3 sentences about approach]
**Tech Stack:** [Key technologies/libraries]

---
```

### Task Structure (Each step is ONE action, 2-5 minutes)

```markdown
### Task N: [Component Name]

**Agent:** @developer / @security-hardener / @performance-optimizer
**Priority:** [CRITICAL/HIGH/MEDIUM/LOW]
**Effort:** [S/M/L/XL]

**Files:**
- Create: `exact/path/to/file.ts`
- Modify: `exact/path/to/existing.ts:123-145`
- Test: `tests/exact/path/to/test.ts`

**Step 1: Write the failing test**
```typescript
test('specific behavior', () => {
    const result = function(input);
    expect(result).toBe(expected);
});
```

**Step 2: Run test to verify it fails**
Run: `npm test path/to/test.ts`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**
```typescript
function example(input) {
    return expected;
}
```

**Step 4: Run test to verify it passes**
Run: `npm test path/to/test.ts`
Expected: PASS

**Step 5: Commit**
```bash
git add tests/path/test.ts src/path/file.ts
git commit -m "feat: add specific feature"
```
```

### Task Specification Rules

- **Exact file paths ALWAYS** — no vague "in the utils folder"
- **Complete code in plan** — not "add validation here"
- **Exact commands with expected output**
- **Each step is one action** (2-5 minutes max)
- **TDD: Test fails → Implement → Test passes → Commit**

---

## Delegation Table

| Concern | Delegate To |
|---------|-------------|
| Code implementation, refactoring, new features, bugs | @developer |
| Vulnerability fixes, auth, input validation, headers | @security-hardener |
| Query optimization, caching, bundle size, lazy loading | @performance-optimizer |
| Unit tests, integration tests, e2e tests | @test-engineer |
| README, API docs, sprint logs, journal, onboarding | @docs-writer |
| CI/CD, Docker, deployment, monitoring | @devops-engineer |
| Frontend, UX, responsive, accessibility | @ui-specialist |
| Full codebase analysis | @project-auditor |
| Requirements clarification, MVP definition | @product-owner |

---

## Parallel Execution (Orchestration)

### When to Use Parallelism

**Use when:**
- Task involves 3+ files with different specialists
- Sprint has independent tasks (no blocking dependencies)
- User requests parallel execution

**Don't use when:**
- Simple single-file changes
- Strict sequential dependencies
- User wants step-by-step

### Dependency Analysis

Read the sprint plan and build a dependency graph:

```
Task A (security fix auth.ts) -> NO deps -> WAVE 1
Task B (refactor hooks) -> NO deps -> WAVE 1
Task C (tests for auth) -> DEPENDS ON A -> WAVE 2
Task D (update docs) -> DEPENDS ON A + B -> WAVE 2
Task E (CI pipeline) -> DEPENDS ON all -> WAVE 3
```

### Wave Template

```markdown
## Wave 1 (Parallel)
| Agent | Skill | Task | Files (exclusive) |
|-------|-------|------|-------------------|
| 1 | @developer | Implement auth | src/auth/* |
| 2 | @test-engineer | Write tests | tests/auth/* |
| 3 | @docs-writer | Update docs | docs/* |

## Wave 2 (after Wave 1 validated)
| 4 | @security-hardener | Review auth | src/auth/* |
```

### Conflict Detection

Before dispatching, verify NO two agents in same wave touch same files:

```
CONFLICT CHECK:
Wave 1: auth/* intersect hooks/* intersect db/* = empty set ✓
```

If conflicts detected, move one task to the next wave.

### Worktree Decision

```
IF agents in same wave might touch same files:
  → Create worktrees: git worktree add .trees/<wave>-<role> feature/<branch>
ELSE:
  → Same directory is fine
```

### Agent Prompt Generation

For each agent, generate a COMPLETE self-contained prompt:
- Specific task description
- EXACT files in scope (only those files)
- Expected output format (from relevant skill)
- Reminder: do NOT touch files outside scope
- Include all context needed (the agent has NO knowledge of other agents)

---

## State Management

### With Beads (preferred)

```bash
# Before dispatch
bd ready --json  # Find unblocked tasks

# During execution
bd update <id> --status in_progress

# After completion
bd close <id>
bd sync
```

### Without Beads (fallback)

Track state in `.agent/dispatch-state.md`:

```markdown
## Current Dispatch
Sprint: 3
Status: Wave 1 executing
Wave 1: [Agent 1: DONE] [Agent 2: RUNNING] [Agent 3: DONE]
Wave 2: PENDING (waiting for Wave 1)
```

---

## Critical Rules

1. **Never write code.** Plan, delegate, review.
2. **Exact file paths.** No vague "in the utils folder."
3. **Dependencies first.** Never schedule before dependencies complete.
4. **No file overlap in same wave.** #1 cause of merge conflicts.
5. **Complete prompts.** Each agent has ZERO context about others.
6. **Validate before next wave.** Never start Wave 2 until Wave 1 verified.
7. **Quick wins early.** Schedule small, high-impact fixes in Sprint 1.
8. **Group related changes.** Do not touch the same file in 5 different tasks.
9. **Verify after each sprint.** Run the auditor again to measure progress.
