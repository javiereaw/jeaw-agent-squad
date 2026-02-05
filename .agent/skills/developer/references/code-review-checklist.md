# Code Review Checklist (Developer Review Mode)

## When to Review

**Mandatory:**
- After completing major features
- Before merge to main
- After fixing complex bugs

**Valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After each task in multi-task plans

---

## Review Process

### Step 1: Get Context

```bash
BASE_SHA=$(git merge-base HEAD main)
HEAD_SHA=$(git rev-parse HEAD)
git diff $BASE_SHA $HEAD_SHA --stat
```

### Step 2: Analyze Changes

For each changed file:
1. **Purpose:** What is this change trying to do?
2. **Correctness:** Does it do what it claims?
3. **Edge cases:** What could break?
4. **Security:** Any vulnerabilities introduced?
5. **Performance:** Any obvious bottlenecks?
6. **Readability:** Can someone else understand this?

### Step 3: Classify Issues

| Severity | Meaning | Action |
|----------|---------|--------|
| **CRITICAL** | Breaks functionality, security hole, data loss | Block merge |
| **IMPORTANT** | Logic errors, missing edge cases, poor patterns | Fix before merge |
| **MINOR** | Style, naming, comments, minor improvements | Note for later |
| **NITPICK** | Personal preference, bike-shedding | Mention once, don't insist |

---

## Review Report Format

```markdown
## Code Review: [Feature/PR Name]

**Commits reviewed:** `{BASE_SHA}..{HEAD_SHA}`
**Files changed:** [count]

### Summary
[2-3 sentences: What was changed and overall assessment]

### Critical Issues
- [ ] **File:line** - Description and why it's critical

### Important Issues
- [ ] **File:line** - Description and suggested fix

### Minor Issues
- **File:line** - Suggestion

### Strengths
- [What was done well]

### Verdict
[APPROVED | APPROVED WITH CHANGES | CHANGES REQUESTED | BLOCKED]
```

---

## Receiving Code Review (When YOU Get Feedback)

### Response Pattern

```
1. READ: Complete feedback without reacting
2. UNDERSTAND: Restate requirement in own words
3. VERIFY: Check against codebase reality
4. EVALUATE: Technically sound for THIS codebase?
5. RESPOND: Technical acknowledgment or reasoned pushback
6. IMPLEMENT: One item at a time, test each
```

### Forbidden Responses

**NEVER say:**
- "You're absolutely right!"
- "Great point!" / "Excellent feedback!"
- "Thanks for catching that!"

**INSTEAD:**
- Restate the technical requirement
- Ask clarifying questions if unclear
- Push back with technical reasoning if wrong
- Just fix it (actions > words)

### When Feedback Is Unclear

```
IF any item is unclear:
  STOP - do not implement anything yet
  ASK for clarification on unclear items

Example:
  Reviewer: "Fix items 1-6"
  You understand 1,2,3,6. Unclear on 4,5.

  WRONG: Implement 1,2,3,6 now, ask about 4,5 later
  RIGHT: "I understand 1,2,3,6. Need clarification on 4,5 before proceeding."
```

### When to Push Back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Conflicts with architectural decisions

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code

### Acknowledging Correct Feedback

```
GOOD: "Fixed. [Brief description of what changed]"
GOOD: "Good catch - [specific issue]. Fixed in [location]."
GOOD: [Just fix it and show the code]

BAD: "You're absolutely right!"
BAD: "Thanks for catching that!"
```

---

## Red Flags

**As reviewer:**
- Approving without reading
- Blocking on style preferences
- Missing security issues
- Not testing the change

**As reviewee:**
- Implementing without understanding
- Blindly accepting all feedback
- Getting defensive instead of technical
- Partial implementation of related items

---

## Critical Rules

1. **Severity matters.** Don't block on nitpicks.
2. **Be specific.** "Line 42: null check missing" not "needs better error handling"
3. **Explain why.** "This could throw if X is null" not just "add null check"
4. **Test-backed.** "Fails when input is empty" is better than "might break"
5. **No performative agreement.** Technical rigor over social comfort.
6. **Verify before implementing.** Check feedback against codebase reality.
