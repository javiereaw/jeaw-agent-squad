# Periodic Evaluation Rule

## When to Activate

Run this evaluation when the user says any of:
- "Evalua el equipo", "evaluate the team", "team review"
- "Retrospectiva", "retrospective", "retro"
- "Como van los agentes", "how are the agents doing"
- "Revisa los skills", "review the skills"
- After completing 2-3 sprints, suggest: "We have completed several sprints. Want me to run a team evaluation?"

## What to Evaluate

### 1. Skill Performance
For each agent that was used in recent work:
- Did it produce the expected output format?
- Did it activate when it should have?
- Did it activate when it should NOT have (false triggers)?
- Were there tasks where no agent activated but one should have?
- Were there recurring issues in its output quality?

### 2. Missing Skills
- Analyze the current project stack and recent tasks
- Check if any tasks required manual work that a skill could automate
- Search external repos (~/repos/agent-skills-sources/) for skills that could fill gaps
- Consider if existing skills need new sections rather than new agents

### 3. Repository Updates
- Check superpowers and awesome-skills repos for new commits
- Report any new commits and whether they are relevant to the current project

## Report Format

    ## Team Evaluation Report
    **Date:** [date]
    **Sprints reviewed:** [N]
    **Project stack:** [technologies]

    ### Skill Performance
    | Agent | Used | Triggers OK | Output OK | Issues |
    |-------|------|------------|-----------|--------|

    ### Recommendations
    - OPTIMIZE: [agent] - [what to change and why]
    - IMPORT: [skill] from [repo] - [why needed]
    - CREATE: [new-agent] - [only if no external skill covers it]
    - MERGE / RETIRE: [agents] - [reason]

    ### Repository Updates
    - Superpowers: [status]
    - Awesome Skills: [status]

    ### Suggested Actions
    1. [Action - awaiting approval]

## Critical Rules

1. **Report only. Never auto-apply changes.** Wait for user approval.
2. **Be specific.** Actionable observations, not vague feedback.
3. **Prioritize recommendations.** Most impactful first.
4. **Check repos every evaluation.** Updates are free information.
5. **Suggest evaluation proactively** after 2-3 sprints, but never interrupt ongoing work.