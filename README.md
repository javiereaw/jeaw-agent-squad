# 🤖 JEAW Agent Squad - Complete Development Squad

Equipo de 11 agentes IA especializados que trabajan juntos para auditar, planificar, construir, testear, securizar, optimizar, documentar, desplegar, **orquestar en paralelo** y **auto-mejorarse**.

Funciona con cualquier proyecto, cualquier stack, cualquier idioma.

## El Equipo

```
                         TÚ (CEO)
                           ↓
                    ┌──────────────┐
                    │  🎯 Tech Lead │  ← Orquestador: planifica sprints,
                    │  (Coordinador)│    delega a especialistas
                    └──────┬───────┘
                           │
                    ┌──────┴───────┐
                    │ 🎭 Orchestrator│  ← Dispatch paralelo: agrupa tareas
                    │  (Paralelo)   │    en waves sin conflictos
                    └──────┬───────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
    ┌─────┴─────┐   ┌─────┴─────┐   ┌─────┴─────┐
    │ 🔍 Auditor │   │ 💻 Developer│   │ 🔒 Security │
    │ (Diagnóstico)│ │ (Construir)│   │ (Blindar)  │
    └────────────┘   └────────────┘   └────────────┘
          │                │                │
    ┌─────┴─────┐   ┌─────┴─────┐   ┌─────┴─────┐
    │ ⚡ Perf    │   │ 🧪 Tester  │   │ 📝 Docs    │
    │ (Optimizar)│   │ (Verificar)│   │ (Documentar)│
    └────────────┘   └────────────┘   └────────────┘
          │                │
    ┌─────┴─────┐   ┌─────┴─────┐
    │ 🚀 DevOps  │   │ ♿ A11y    │
    │ (Desplegar)│   │ (Accesible)│
    └────────────┘   └────────────┘
                           │
                    ┌──────┴───────┐
                    │ 🧬 Architect  │  ← Meta-agente: evalúa, optimiza,
                    │ (Evolucionar)│    crea agentes, gestiona repos
                    └──────────────┘
```

| Agente | Skill | Función |
|--------|-------|---------|
| 🔍 Project Auditor | `project-auditor` | Auditoría profunda del proyecto en 8 dimensiones |
| 🎯 Tech Lead | `tech-lead` | Planificación de sprints, delegación, coordinación |
| 💻 Developer | `developer` | Implementación de código, refactoring, bug fixes |
| 🔒 Security Hardener | `security-hardener` | Vulnerabilidades, validación de inputs, headers |
| ⚡ Performance Optimizer | `performance-optimizer` | Queries, caching, virtualización, bundle size |
| 🧪 Test Engineer | `test-engineer` | Tests unitarios, integración, e2e |
| 📝 Docs Writer | `docs-writer` | README, JSDoc, API docs, ADRs |
| 🚀 DevOps Engineer | `devops-engineer` | CI/CD, Docker, deployment, dev observability |
| ♿ Accessibility Auditor | `accessibility-auditor` | WCAG 2.1 AA, ARIA, navegación por teclado |
| 🧬 Agent Architect | `agent-architect` | Meta-agente: evalúa, optimiza, crea agentes, gestiona repos externos |
| 🎭 Orchestrator | `orchestrator` | Dispatch paralelo de agentes en Antigravity Agent Manager |

## Instalación

Un solo comando. Sin dependencias extra. Todo embebido en el script.

El instalador hace tres cosas:
1. **Instala los 11 agentes** en la ruta que elijas
2. **Clona dos repositorios externos** de skills en `~/repos/agent-skills-sources/`
3. **Instala cuatro reglas** de comportamiento (transparencia, onboarding, evaluación periódica, convergencia)

### Instalación Remota (una línea)

```bash
# Linux / macOS / Git Bash — instala en proyecto actual
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USER/jeaw-agent-squad/main/install-agents.sh) --option 4

# Instalación global (Antigravity + Claude Code)
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USER/jeaw-agent-squad/main/install-agents.sh) --option 3
```

### Instalación Local

Clona el repo y ejecuta:

```bash
git clone https://github.com/YOUR_GITHUB_USER/jeaw-agent-squad.git
cd jeaw-agent-squad
```

### Windows (PowerShell)

```powershell
.\install-agents.ps1
```

Si da error de política de ejecución:
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
.\install-agents.ps1
```

### Linux / macOS / Git Bash

```bash
bash install-agents.sh
```

### Menú interactivo

```
¿Dónde quieres instalar los agentes?

  1) Global Antigravity   → ~/.gemini/antigravity/skills/
  2) Global Claude Code   → ~/.claude/skills/
  3) Global ambos         → Antigravity + Claude Code
  4) Proyecto actual      → .agent/skills/ + .claude/skills/
  5) Ruta personalizada   → tú eliges
```

**Recomendación:** La opción **4** instala en ambas rutas del proyecto (`.agent/skills/` para Antigravity y `.claude/skills/` para Claude Code), asegurando que ambas herramientas lean los skills automáticamente.

### Opciones de línea de comandos

```bash
bash install-agents.sh --option 4      # Non-interactive: elige opción directamente
bash install-agents.sh --version        # Muestra la versión instalada
bash install-agents.sh --help           # Muestra ayuda
```

### Actualización

Para actualizar a la última versión:

```bash
# Opción 1: Si clonaste el repo
cd jeaw-agent-squad
git pull
bash install-agents.sh --option 4      # Re-instala con la opción que uses

# Opción 2: Usando el updater (comprueba versión automáticamente)
bash update.sh

# Opción 3: Remote update (sin clonar)
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USER/jeaw-agent-squad/main/install-agents.sh) --option 4
```

El instalador **siempre sobreescribe** los skills con la última versión. Tus archivos de proyecto (código, docs, Beads) nunca se tocan.

Para ver la versión instalada: `cat .agent/.version`

### Compatibilidad

Cada herramienta busca SKILL.md en su propia ruta. Por eso la opción 4 instala en dos rutas del proyecto:

| Herramienta | Ruta proyecto | Ruta global |
|-------------|---------------|-------------|
| **Antigravity** | `.agent/skills/` | `~/.gemini/antigravity/skills/` |
| **Claude Code** | `.claude/skills/` | `~/.claude/skills/` |
| Gemini CLI | `.gemini/skills/` | `~/.gemini/skills/` |
| Cursor | `.cursor/skills/` | `~/.cursor/skills/` |
| Codex | `.codex/skills/` | `~/.codex/skills/` |
| OpenCode | `.opencode/skills/` | `~/.config/opencode/skills/` |

El formato SKILL.md es el mismo estándar abierto (Agent Skills) para todas las herramientas.

## Estructura Generada (Opción 4)

```
proyecto/
├── .agent/                          ← FUENTE DE VERDAD (canonical)
│   ├── .version                     ← Versión instalada de los agentes
│   ├── rules/
│   │   ├── transparency.md
│   │   ├── onboarding.md
│   │   ├── periodic-evaluation.md
│   │   └── convergence-architecture.md
│   └── skills/
│       ├── project-auditor/SKILL.md
│       ├── tech-lead/SKILL.md
│       ├── developer/SKILL.md
│       ├── security-hardener/SKILL.md
│       ├── performance-optimizer/SKILL.md
│       ├── test-engineer/SKILL.md
│       ├── docs-writer/SKILL.md
│       ├── devops-engineer/SKILL.md
│       ├── accessibility-auditor/SKILL.md
│       ├── orchestrator/SKILL.md
│       └── agent-architect/SKILL.md
│
├── .claude/                         ← SYMLINK → .agent/
│   ├── rules/ → ../.agent/rules/
│   └── skills/ → ../.agent/skills/
│
~/repos/agent-skills-sources/        ← Repositorios externos
├── superpowers/                     ← obra/superpowers
└── awesome-skills/                  ← sickn33/antigravity-awesome-skills
```

### Sincronización por Symlinks

Un cambio en `.agent/skills/` se refleja **automáticamente** en `.claude/skills/` (y cualquier otra herramienta enlazada). No hay duplicación ni riesgo de desincronización.

En Linux/Mac se usan symlinks (`ln -s`). En Windows se usan directory junctions (`mklink /J`), que funcionan sin privilegios de administrador.

Para añadir más herramientas en el futuro (Cursor, Gemini CLI, Codex...), basta con crear un symlink adicional:

```bash
# Linux/Mac
ln -s .agent/skills .cursor/skills

# Windows (PowerShell como admin o con Developer Mode)
cmd /c "mklink /J .cursor\skills .agent\skills"
```

## Reglas de Comportamiento

Las reglas se instalan en `rules/` y aplican a todos los agentes:

| Regla | Función |
|-------|---------|
| `transparency.md` | Cada agente se identifica al inicio de su respuesta: `[🔒 security-hardener] — razón` |
| `onboarding.md` | Cuando detecta un proyecto nuevo, sugiere configurar dev observability, recomendar skills, e inicializar Beads |
| `periodic-evaluation.md` | Define el proceso de retrospectiva del equipo tras 2-3 sprints |
| `convergence-architecture.md` | Define la infraestructura de coordinación multi-agente (Beads, Worktrees, gemini-mcp) |

## Workflow Típico

### Fase 1: Auditoría
```
Tú: "Audita este proyecto"
→ [🔍 project-auditor] ejecuta 8 fases de análisis
→ Genera AUDIT_REPORT.md con puntuaciones y hallazgos
```

### Fase 2: Planificación
```
Tú: "Crea un plan para arreglar los hallazgos"
→ [🎯 tech-lead] lee el audit report
→ Genera sprint plan con tareas asignadas a especialistas
```

### Fase 3: Ejecución
```
Tú: "Ejecuta el Sprint 1"
→ [🎯 tech-lead] delega:
   → [🔒 security-hardener] arregla validación CSV, añade headers
   → [💻 developer] extrae utilidades compartidas, arregla hooks
   → [♿ accessibility-auditor] añade ARIA labels
```

### Fase 4: Verificación
```
Tú: "Audita otra vez"
→ [🔍 project-auditor] re-audita
→ Puntuación sube (ej: 70/100 → 85/100)
```

### Fase 5: Despliegue
```
Tú: "Prepara CI/CD y deployment"
→ [🚀 devops-engineer] crea pipeline, Dockerfile, y configura dev observability
→ [🧪 test-engineer] añade tests de rutas críticas
→ [📝 docs-writer] actualiza README
```

### Fase 6: Evaluación
```
Tú: "Evalúa el equipo" / "Retrospectiva" / "Cómo van los agentes"
→ [🧬 agent-architect] analiza:
   → Rendimiento de cada skill (triggers, output, calidad)
   → Skills que faltan para el proyecto
   → Actualizaciones disponibles en repos externos
→ Presenta informe con recomendaciones
→ Tú apruebas o rechazas cada sugerencia
```

## Orquestación Paralela (Agent Manager)

Este es el flujo más potente del equipo. Antigravity tiene un **Agent Manager** que permite ejecutar múltiples agentes en paralelo en workspaces separados.

El **orchestrator** es el agente que descompone un sprint en tareas paralelas:

```
Tú: "Ejecuta el Sprint 1 en paralelo"
→ [🎭 orchestrator] analiza el sprint plan del tech-lead
→ Agrupa tareas en "Waves" (oleadas sin conflictos de archivos)
→ Genera un prompt completo y autocontenido para cada agente
→ Te dice exactamente qué hacer en Agent Manager:

   Wave 1 (Parallel):
   ├── Workspace 1: security-hardener → Fix XSS en auth (src/auth/*)
   ├── Workspace 2: developer → Refactor hooks (src/hooks/*)
   └── Workspace 3: performance-optimizer → Optimize queries (src/db/*)

   Wave 2 (después de Wave 1):
   ├── Workspace 4: test-engineer → Tests para auth fix
   └── Workspace 5: docs-writer → Sprint log + journal

   Wave 3 (validación):
   └── Workspace 6: project-auditor → Verifica todo
```

Si no usas Agent Manager (estás en Editor, Claude Code o Cursor), el orchestrator te da el mismo plan pero en orden secuencial.

## Dev Observability

El devops-engineer tiene como prioridad número 1 configurar un sistema de logging automático en cada proyecto. Esto crea un archivo `.dev-errors.log` que:

- Captura errores de servidor, cliente y build automáticamente
- Funciona con cualquier stack (Next.js, Python, Go, PHP, Rust, etc.)
- Usa formato universal parseable por cualquier agente IA
- Solo se activa en desarrollo (nunca en producción)

Para que un agente arregle errores, simplemente dile: *"Lee .dev-errors.log y arregla los errores"*

## Repositorios Externos

El instalador clona automáticamente dos repositorios de skills:

| Repo | Contenido | Uso |
|------|-----------|-----|
| [obra/superpowers](https://github.com/obra/superpowers) | Metodología: TDD, brainstorming, verificación, debugging | Skills de proceso y calidad |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | 600+ skills especializados (seguridad, marketing, CRM, etc.) | Catálogo para cherry-pick |

El agent-architect es el único que gestiona estos repos. Nunca se instalan todos los 600+ skills. El flujo es:

1. Tú dices: *"Recomienda skills para este proyecto"*
2. El agent-architect analiza tu stack, lee los repos, compara con los skills instalados
3. Te presenta un informe con recomendaciones (IMPORTAR / IGNORAR)
4. Tú apruebas y él instala solo lo que apruebas

Para comprobar actualizaciones: *"Hay actualizaciones en los repos de skills?"*

## Idioma

Los agentes detectan automáticamente tu idioma. Si les hablas en español, responden en español. Si les hablas en inglés, responden en inglés. Los términos técnicos (nombres de funciones, comandos, código) se mantienen siempre en inglés.

## Archivos del Repositorio

```
├── install-agents.ps1   ← Instalador Windows (PowerShell)
├── install-agents.sh    ← Instalador Linux/macOS/Git Bash
├── update.sh            ← Actualizador (comprueba versión y re-instala)
├── VERSION              ← Versión actual del repo
├── CHANGELOG.md         ← Historial de cambios
├── LICENSE              ← MIT License
└── README.md            ← Este archivo
```

## Arquitectura de Convergencia (Multi-Modelo)

Los agentes incluyen soporte integrado para la **Arquitectura de Convergencia**, que añade una capa de infraestructura para coordinar agentes Claude y Gemini trabajando en paralelo. Todo es **opcional y retrocompatible** — los agentes funcionan igual sin ella.

### Componentes

| Herramienta | Función | Instalación |
|-------------|---------|-------------|
| [Beads (bd)](https://github.com/steveyegge/beads) | Tracker de tareas Git-backed | `curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh \| bash` |
| Git Worktrees | Aislamiento físico por agente | Nativo en Git |
| [gemini-mcp](https://github.com/RLabs-Inc/gemini-mcp) | Gemini como oráculo de contexto | `claude mcp add gemini -s user -- env GEMINI_API_KEY=KEY npx -y @rlabs-inc/gemini-mcp` |
| [antigravity-claude-proxy](https://github.com/badrisnarayanan/antigravity-claude-proxy) | Unifica suscripciones Claude + Gemini | `git clone ... && npm install && npm start` |
| [Vibe Kanban](https://github.com/BloopAI/vibe-kanban) | Dashboard visual de progreso | `npx vibe-kanban` |

### Cómo Funciona

```
╔══════════════════════════════════════════════════════╗
║  CAPA DE ROLES (Skills)                              ║
║  11 agentes con SKILL.md definiendo QUÉ hacen        ║
╠══════════════════════════════════════════════════════╣
║  CAPA DE INFRAESTRUCTURA (Convergencia)              ║
║  Beads + Worktrees + gemini-mcp + proxy + Kanban     ║
║  Definen CÓMO se coordinan                           ║
╠══════════════════════════════════════════════════════╣
║  CAPA DE MODELOS (Especialización)                   ║
║  Claude → Ejecución (developer, security, perf...)   ║
║  Gemini → Planificación + Auditoría (auditor, lead)  ║
╚══════════════════════════════════════════════════════╝
```

### Agentes con Integración Beads

Todos los agentes incluyen una sección **Task Lifecycle** que se activa automáticamente cuando detectan Beads:

- **tech-lead:** Registra tareas en Beads con `bd create` en vez de solo texto
- **orchestrator:** Usa Beads + Git Worktrees en vez de `dispatch-state.md`
- **agent-architect:** Consulta métricas de Beads para evaluación objetiva
- **Todos los ejecutores:** Siguen el ciclo `bd ready` → `bd update` → trabajo → `bd close` → `bd sync`

### Activar en un Proyecto

```bash
# 1. Instalar agentes (ya incluyen convergencia)
bash install-agents.sh    # Opción 4

# 2. Inicializar Beads
bd init

# 3. (Opcional) Configurar gemini-mcp
claude mcp add gemini -s user -- env GEMINI_API_KEY=TU_KEY npx -y @rlabs-inc/gemini-mcp

# 4. (Opcional) Dashboard visual
npx vibe-kanban
```

### Flujo con Convergencia Activa

```
"Audita este proyecto" → Gemini (1M tokens, visión global)
  ↓
"Crea un sprint plan"  → Tech Lead registra tareas en Beads (bd create)
  ↓
"Ejecuta en paralelo"  → Orchestrator crea Worktrees + asigna Waves
  ↓
Wave 1: Claude Code en .trees/w1-security/ + .trees/w1-refactor/
  ↓
Cada agente: bd update → trabaja → bd close → bd sync
  ↓
Merge branches → bd ready --json → Wave 2
  ↓
Gemini audita cambios de Claude (auditoría cruzada)
```

### Sin Convergencia

Si no activas Beads, los agentes funcionan exactamente igual que antes. Los sprints son texto, el estado se trackea manualmente, y la ejecución es secuencial. No hay dependencia rota.
