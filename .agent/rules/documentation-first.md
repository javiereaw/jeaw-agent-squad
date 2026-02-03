# Documentation-First Rule

## Purpose

Every project must have documentation comprehensive enough that **any new team member can understand the entire project in record time**.

This is not optional. This is how professional teams work.

## The Standard

A new developer joining the team should be able to:

1. **In 5 minutes**: Understand what the project does and why it exists
2. **In 30 minutes**: Set up a local development environment
3. **In 2 hours**: Understand the architecture and make their first contribution
4. **In 1 day**: Work independently on most tasks

If your documentation doesn't achieve this, it's incomplete.

## Required Documentation

### Tier 1: MUST HAVE (Day 1)

| Document | Location | Content |
|----------|----------|---------|
| **README.md** | Root | Project purpose, quick start, tech stack |
| **CONTRIBUTING.md** | Root | How to contribute, PR process, coding standards |
| **docs/ARCHITECTURE.md** | docs/ | System overview, components, data flow |
| **docs/SETUP.md** | docs/ | Complete local setup instructions |

### Tier 2: SHOULD HAVE (Week 1)

| Document | Location | Content |
|----------|----------|---------|
| **docs/STACK.md** | docs/ | Why each technology was chosen |
| **docs/API.md** | docs/ | API endpoints, request/response examples |
| **docs/GLOSSARY.md** | docs/ | Domain-specific terms explained |
| **CHANGELOG.md** | Root | Version history with changes |

### Tier 3: NICE TO HAVE (Ongoing)

| Document | Location | Content |
|----------|----------|---------|
| **docs/adrs/** | docs/adrs/ | Architecture Decision Records |
| **docs/TROUBLESHOOTING.md** | docs/ | Common issues and solutions |
| **docs/RUNBOOKS.md** | docs/ | Operational procedures |
| **PROJECT_JOURNAL.md** | Root | Chronological project history |

## Document Templates

### README.md Template

```markdown
# Project Name

One-line description of what this project does.

## Why This Exists

Brief explanation of the problem this solves.

## Quick Start

\`\`\`bash
git clone <repo>
cd <project>
npm install
npm run dev
\`\`\`

## Tech Stack

- **Frontend**: React, TypeScript
- **Backend**: Node.js, Express
- **Database**: PostgreSQL
- **Infra**: Docker, GitHub Actions

## Documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Setup Guide](docs/SETUP.md)
- [API Reference](docs/API.md)
- [Contributing](CONTRIBUTING.md)

## Team

- Product Owner: [Name]
- Tech Lead: [Name]
- Developers: [Names]
```

### ARCHITECTURE.md Template

```markdown
# Architecture Overview

## System Diagram

\`\`\`
[Client] → [API Gateway] → [Backend Services] → [Database]
                ↓
          [Cache Layer]
\`\`\`

## Components

### Frontend
- **Location**: `/src/client`
- **Framework**: React 18
- **State**: Redux Toolkit
- **Routing**: React Router v6

### Backend
- **Location**: `/src/server`
- **Framework**: Express.js
- **Auth**: JWT + Sessions
- **Validation**: Zod

### Database
- **Type**: PostgreSQL 15
- **ORM**: Prisma
- **Migrations**: `/prisma/migrations`

## Data Flow

1. User action triggers React component
2. Component dispatches Redux action
3. Action calls API endpoint
4. Backend validates request
5. Database query executes
6. Response flows back through layers

## Key Decisions

See [Architecture Decision Records](adrs/) for historical context.
```

## When to Write Documentation

| Event | Documentation Action |
|-------|---------------------|
| Project created | README, SETUP, ARCHITECTURE (Day 1) |
| New feature added | Update relevant docs + CHANGELOG |
| Architecture change | New ADR + update ARCHITECTURE.md |
| Bug fixed | Update TROUBLESHOOTING if relevant |
| Sprint completed | Update PROJECT_JOURNAL |
| New team member joins | Verify onboarding docs are current |

## The 📝 docs-writer Agent

The docs-writer agent is responsible for documentation. Invoke it:

```
"Document the authentication flow"
"Update the README with the new setup steps"
"Create an ADR for the database migration"
"Write onboarding docs for new developers"
```

## Quality Checklist

Before considering documentation "done":

- [ ] Can a new developer set up the project using only the docs?
- [ ] Are all environment variables documented?
- [ ] Are all API endpoints documented with examples?
- [ ] Is the architecture diagram up to date?
- [ ] Are deployment procedures documented?
- [ ] Are common errors and their solutions documented?
- [ ] Is the tech stack and reasoning documented?
- [ ] Are coding standards documented?

## Maintenance

Documentation must be treated as **code**:

1. **Review docs in PRs**: Changes to code should include doc updates
2. **Test the docs**: Periodically follow setup instructions on a fresh machine
3. **Version the docs**: Major changes should be reflected in CHANGELOG
4. **Assign ownership**: Someone is responsible for doc quality

## Why This Matters

1. **Faster onboarding**: New hires productive in hours, not weeks
2. **Reduced interruptions**: "Read the docs" is a valid answer
3. **Knowledge preservation**: When people leave, knowledge stays
4. **Better decisions**: ADRs explain why things are the way they are
5. **Professionalism**: Good docs signal a mature, well-run project
6. **Self-service**: Team members can find answers independently

## Consequences of Ignoring This Rule

- New team members struggle for weeks
- Same questions asked repeatedly
- Knowledge trapped in individuals' heads
- Onboarding becomes "shadow someone for a month"
- Technical debt accumulates undocumented
- Architecture decisions forgotten, mistakes repeated
