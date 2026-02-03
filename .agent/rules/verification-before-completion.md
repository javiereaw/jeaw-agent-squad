# Verification Before Completion Rule

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

Claiming work is complete without verification is dishonesty, not efficiency.

**If you haven't run the verification command in this message, you cannot claim it passes.**

## The Gate Function

```
BEFORE claiming any status:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Verification Requirements

| Claim | Requires | NOT Sufficient |
|-------|----------|----------------|
| "Tests pass" | Test command output: 0 failures | Previous run, "should pass" |
| "Linter clean" | Linter output: 0 errors | Partial check |
| "Build succeeds" | Build command: exit 0 | Linter passing |
| "Bug fixed" | Test original symptom: passes | Code changed, assumed fixed |
| "Task complete" | All acceptance criteria verified | Agent reports "success" |

## Red Flags - STOP

If you catch yourself:
- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Done!")
- About to commit/push/PR without fresh verification
- Trusting agent success reports without checking
- Relying on partial verification
- Thinking "just this once"

**ALL of these mean: STOP. Run the verification.**

## Common Rationalizations (REJECT ALL)

| Excuse | Reality |
|--------|---------|
| "Should work now" | RUN the verification |
| "I'm confident" | Confidence is not evidence |
| "Just this once" | No exceptions |
| "Linter passed" | Linter is not compiler |
| "Agent said success" | Verify independently |
| "Partial check is enough" | Partial proves nothing |

## Evidence Patterns

**Tests:**
```
RUN: npm test
SEE: 34/34 pass, exit 0
CLAIM: "All tests pass"

NOT: "Should pass now" / "Looks correct"
```

**Build:**
```
RUN: npm run build
SEE: exit 0, no errors
CLAIM: "Build succeeds"

NOT: "Linter passed so build should work"
```

**Task Completion:**
```
READ: Acceptance criteria from task spec
CHECK: Each criterion individually
REPORT: "Criteria met: [list]" or "Missing: [list]"

NOT: "Tests pass, task complete"
```

## Enforcement

This rule applies to ALL agents, ALL claims, ALL the time.

When marking a task as DONE:
1. Re-read the acceptance criteria
2. Verify EACH criterion has evidence
3. Run verification commands
4. ONLY THEN report completion

**No shortcuts for verification. Run the command. Read the output. THEN claim the result.**
