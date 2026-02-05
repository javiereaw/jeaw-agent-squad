# Debugging Guide (Developer Debug Mode)

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.
Random fixes waste time and create new bugs.

---

## The Four Phases

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - Read stack traces completely
   - Note line numbers, file paths, error codes
   - They often contain the exact solution

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - If not reproducible → gather more data, don't guess

3. **Check Recent Changes**
   - `git diff` — what changed?
   - Recent commits, new dependencies, config changes
   - Environmental differences

4. **Gather Evidence in Multi-Component Systems**
   ```
   For EACH component boundary:
     - Log what data enters component
     - Log what data exits component
     - Verify environment/config propagation

   Run once to gather evidence showing WHERE it breaks
   THEN analyze evidence to identify failing component
   THEN investigate that specific component
   ```

5. **Trace Data Flow**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing UP until you find the source
   - Fix at source, not at symptom

---

### Phase 2: Pattern Analysis

1. **Find Working Examples**
   - Locate similar working code in same codebase
   - What works that's similar to what's broken?

2. **Compare Against References**
   - Read reference implementation COMPLETELY
   - Don't skim — read every line

3. **Identify Differences**
   - What's different between working and broken?
   - List every difference, however small
   - Don't assume "that can't matter"

---

### Phase 3: Hypothesis and Testing

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Write it down
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

---

### Phase 4: Implementation

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - MUST have before fixing (TDD)

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue actually resolved?

4. **If Fix Doesn't Work**
   - Count: How many fixes have you tried?
   - If < 3: Return to Phase 1, re-analyze
   - **If >= 3: STOP and question the architecture**

---

## The "3 Failures" Rule

**Pattern indicating architectural problem:**
- Each fix reveals new problem in different place
- Fixes require "massive refactoring"
- Each fix creates new symptoms elsewhere

**STOP and discuss with user before attempting more fixes.**

---

## Red Flags - STOP and Return to Phase 1

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "One more fix attempt" (when already tried 2+)

**ALL of these mean: STOP. Return to Phase 1.**

---

## Common Rationalizations (REJECT ALL)

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too |
| "Emergency, no time for process" | Systematic is FASTER than thrashing |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "I see the problem, let me fix it" | Seeing symptoms != understanding root cause |

---

## Debug Report Format

```markdown
## Debug Report: [Issue Title]

### Phase 1: Root Cause Investigation
**Error message:** [exact text]
**Reproducible:** Yes/No (steps: ...)
**Recent changes:** [git diff summary]
**Evidence gathered:** [logs, traces]
**Root cause identified:** [specific cause]

### Phase 2: Pattern Analysis
**Working example found:** [file:line]
**Difference identified:** [what's different]

### Phase 3: Hypothesis
**Hypothesis:** [I think X because Y]
**Test performed:** [minimal change]
**Result:** Confirmed/Rejected

### Phase 4: Fix
**Failing test added:** [test file:line]
**Fix applied:** [file:line, what changed]
**Verification:** All tests pass / Issue resolved

### Summary
- Root cause: [one sentence]
- Fix: [one sentence]
- Prevent future: [if applicable]
```

---

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, trace | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |
