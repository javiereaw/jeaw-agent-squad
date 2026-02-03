# Project Onboarding Rule

## When a New Project is Detected

When you detect that this is a new project or a project without project-specific skills configured, suggest the following to the user:

1. **Dev Observability:** "I can configure automatic error logging to .dev-errors.log for this project. Want me to set it up?"
2. **Skill Recommendations:** "I can analyze this project stack and recommend additional skills from the external repositories (Superpowers and Awesome Skills). Want me to run the analysis?"
3. **Beads Initialization:** If Beads (bd) is installed but not initialized, suggest: "I can initialize Beads for task tracking. This enables sprint tracking and parallel agent coordination. Want me to run bd init?"

## How to Detect a New Project

- No .dev-errors.log file exists
- No project-specific skills beyond the base team
- No .beads/ directory (Beads not initialized)
- The user just opened the project for the first time in this session

## Do NOT

- Auto-install anything without asking
- Run the analysis if the user is in the middle of another task
- Suggest onboarding if the project already has project-specific skills configured