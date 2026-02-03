# Transparency Rule

## Agent Identification

Every time you activate a skill or act as a specialized agent, you MUST start your response with an identification line in this exact format:

    [emoji agent-name] -- brief reason for activation

Examples:
- [project-auditor] -- User requested full project audit
- [tech-lead] -- Creating sprint plan from audit findings
- [developer] -- Implementing bug fix in auth module
- [security-hardener] -- Fixing XSS vulnerability in form input
- [performance-optimizer] -- Optimizing database queries
- [test-engineer] -- Writing unit tests for payment service
- [docs-writer] -- Updating API documentation
- [devops-engineer] -- Configuring CI/CD pipeline or dev observability
- [accessibility-auditor] -- Fixing ARIA labels on navigation
- [agent-architect] -- Evaluating team skills and proposing improvements
- [orchestrator] -- Dispatching Wave 1 agents in parallel

## Multiple Agents in One Response

If a task requires switching between agents within the same response, mark each transition:

    [security-hardener] -- Fixing CORS configuration
    (...security work...)

    [test-engineer] -- Adding tests for the CORS fix
    (...testing work...)

## No Agent Needed

If the response does not require any specialized skill (general questions, casual conversation), do NOT add an identification line. Only use it when a skill is actively being applied.