# 🤖 JEAW Agent Squad

Equipo de 11 agentes IA especializados (7 core + 4 on-demand) + infraestructura de convergencia multi-modelo.

Auditan, planifican, construyen, testean, securizan, optimizan, documentan, despliegan, coordinan en paralelo y evolucionan.

Funciona con cualquier proyecto, cualquier stack, cualquier idioma.

---

## Quick Start

### 1. Bootstrap (una sola vez en tu máquina)

```powershell
cd C:\www\agentes
.\bootstrap.ps1
```

Instala la infraestructura: Beads, gemini-mcp, proxy. Seguro de re-ejecutar.

### 2. Nuevo proyecto (30 segundos)

```powershell
cd C:\www\agentes
.\new-project.ps1 -Name "roi-inmobiliario"
```

Crea `C:\www\roi-inmobiliario` con los 11 agentes + Beads inicializado.

### 3. Trabajar

Abre el proyecto en Antigravity o Claude Code y di:

```
"Audita este proyecto"
"Crea un sprint plan"
"Ejecuta el Sprint 1"
"Ejecuta el Sprint 1 en paralelo"
```

---

## El Equipo

```
                            TÚ (CEO)
                               ↓
                        ┌─────────────┐
                        │ 🎯 Lead Agent│  ← Planifica + coordina
                        └──────┬──────┘
                               │
      ┌────────────────────────┼────────────────────────┐
      │                        │                        │
┌─────┴─────┐           ┌─────┴─────┐           ┌─────┴─────┐
│💻 Developer│           │🔒 Security │           │⚡ Perf     │
│  +Debug   │           │  Hardener │           │ Optimizer │
│  +Review  │           └───────────┘           └───────────┘
└───────────┘
      │
┌─────┴─────┐           ┌───────────┐           ┌───────────┐
│🧪 Test     │           │🚀 DevOps  │           │🎨 UI       │
│  Engineer │           │  Engineer │           │Specialist │
└───────────┘           └───────────┘           └───────────┘

─────────────────── ON-DEMAND ───────────────────
┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐
│🔍 Auditor │  │📝 Docs    │  │🎭 Product │  │🧬 Agent   │
│           │  │  Writer  │  │  Owner   │  │ Architect │
└───────────┘  └───────────┘  └───────────┘  └───────────┘
```

### Core (7 agentes - Siempre disponibles)

| Agente | Skill | Función |
|--------|-------|---------|
| 🎯 Lead Agent | `lead-agent` | Planificación + coordinación (fusión tech-lead + orchestrator) |
| 💻 Developer | `developer` | Implementación, debug mode, review mode |
| 🔒 Security Hardener | `security-hardener` | OWASP, validación, headers |
| ⚡ Performance Optimizer | `performance-optimizer` | Queries, caching, bundle size |
| 🧪 Test Engineer | `test-engineer` | Tests unitarios, integración, e2e, TDD |
| 🚀 DevOps Engineer | `devops-engineer` | CI/CD, Docker, dev observability |
| 🎨 UI Specialist | `ui-specialist` | Frontend + UX + Accesibilidad (WCAG 2.1 AA) |

### On-Demand (4 agentes - Cuando se invocan)

| Agente | Skill | Función |
|--------|-------|---------|
| 🔍 Project Auditor | `project-auditor` | Auditoría profunda en 8 dimensiones |
| 📝 Docs Writer | `docs-writer` | README, ADRs, sprint logs, journal |
| 🎭 Product Owner | `product-owner` | Requirements, MVP, user stories |
| 🧬 Agent Architect | `agent-architect` | Evalúa, optimiza, crea agentes |

---

## Scripts

### `bootstrap.ps1` — Infraestructura global (una vez)

```powershell
.\bootstrap.ps1              # Instala todo
.\bootstrap.ps1 -Status      # Verifica qué está instalado
.\bootstrap.ps1 -SkipProxy   # Salta componentes específicos
.\bootstrap.ps1 -SkipDaemon  # Sin orquestador automático
```

| Qué instala | Para qué |
|-------------|----------|
| Beads (bd) | Task tracker Git-backed entre agentes |
| gemini-mcp | Gemini como oráculo de contexto para Claude Code CLI |
| antigravity-claude-proxy | Unifica suscripciones Claude + Gemini |
| Vibe Kanban (info) | Dashboard visual (se ejecuta con `npx`) |
| Orchestrator Daemon | Orquestación automática multi-agente |

### `new-project.ps1` — Setup de proyecto (30 segundos)

```powershell
.\new-project.ps1 -Name "roi-inmobiliario"       # Crea en C:\www\
.\new-project.ps1 -Name "scorm-aragon"            # Otro proyecto
.\new-project.ps1 -Path "D:\otro\sitio"           # Ruta custom
.\new-project.ps1 -Name "test" -SkipBeads         # Sin Beads
```

Qué hace:
1. Crea el directorio si no existe
2. Instala AGENTS.MD + 11 skills (opción 4 del instalador)
3. Inicializa Git si no tiene
4. Inicializa Beads para task tracking

### `install-agents.ps1` — Instalador de agentes

```powershell
# Desde el repo local
.\install-agents.ps1          # Menú interactivo (5 opciones)

# Desde cualquier lugar (descarga de GitHub)
irm https://raw.githubusercontent.com/javiereaw/jeaw-agent-squad/main/install-agents.ps1 | iex
```

Para re-instalar/actualizar agentes en un proyecto existente:
```powershell
cd C:\www\mi-proyecto
powershell -ExecutionPolicy Bypass -File C:\www\agentes\install-agents.ps1
# Elige opción 4
```

El instalador descarga siempre la última versión del repositorio.

### `install-agents.sh` — Instalador Linux/macOS

```bash
bash install-agents.sh                # Interactivo
bash install-agents.sh --option 4     # Non-interactive
bash install-agents.sh --version      # Ver versión
```

### `update.sh` — Actualizador con versión

```bash
bash update.sh    # Compara VERSION local vs GitHub, re-instala si hay nueva
```

---

## Estructura de un Proyecto Configurado

```
mi-proyecto/
├── .agent/                          ← FUENTE DE VERDAD (canonical)
│   ├── AGENTS.MD                    ← Reglas globales + Iron Laws
│   └── skills/
│       ├── lead-agent/SKILL.md      ← Core (7)
│       ├── developer/SKILL.md
│       ├── security-hardener/SKILL.md
│       ├── performance-optimizer/SKILL.md
│       ├── test-engineer/SKILL.md
│       ├── devops-engineer/SKILL.md
│       ├── ui-specialist/SKILL.md
│       ├── project-auditor/SKILL.md ← On-demand (4)
│       ├── docs-writer/SKILL.md
│       ├── product-owner/SKILL.md
│       └── agent-architect/SKILL.md
├── .claude/                         ← SYMLINK
│   └── skills/ → .agent/skills/
├── .beads/                          ← Task tracker (si activo)
└── tu código...
```

El symlink sincroniza automáticamente — editar en `.agent/` actualiza `.claude/` sin duplicación.

---

## Workflow

### Ciclo básico

```
"Audita este proyecto"              → AUDIT_REPORT.md con puntuaciones
"Crea un plan para los hallazgos"   → Sprint plan con tareas asignadas
"Ejecuta el Sprint 1"               → Agentes trabajan secuencialmente
"Audita otra vez"                    → Mide progreso (70 → 85/100)
```

### Ejecución paralela

```
"Ejecuta el Sprint 1 en paralelo"
→ Orchestrator agrupa en Waves (sin conflictos de archivos)

   Wave 1 (simultáneo):
   ├── .trees/w1-security/    → security-hardener
   ├── .trees/w1-refactor/    → developer
   └── .trees/w1-perf/        → performance-optimizer

   Wave 2 (tras Wave 1):
   ├── .trees/w2-tests/       → test-engineer
   └── .trees/w2-docs/        → docs-writer

   Wave 3 (validación):
   └── project-auditor verifica todo
```

### Evaluación del equipo

```
"Evalúa el equipo" / "Retrospectiva"
→ Agent Architect analiza rendimiento, sugiere mejoras, cherry-pick de repos externos
```

---

## Modos de Operación

### Modo Manual (por defecto)

Tú diriges cada agente desde una ventana/terminal:

```
Ventana 1 (VS Code + Claude):    "Audita este proyecto"
Ventana 2 (Antigravity/Gemini):  "Crea un sprint plan"
Ventana 3 (VS Code + Claude):    "Ejecuta la tarea DEV-001"
```

- Control total sobre cada agente
- Ideal para tareas exploratorias o debugging
- Máximo paralelismo = número de ventanas abiertas

### Modo Automático (daemon)

El orchestrator-daemon monitorea Beads y ejecuta tareas automáticamente:

```powershell
# En el proyecto donde quieres orquestación automática
node C:\www\agentes\daemon\orchestrator-daemon.js --project .

# Con dry-run para ver qué haría sin ejecutar
node C:\www\agentes\daemon\orchestrator-daemon.js --project . --dry-run

# Ver estado
node C:\www\agentes\daemon\orchestrator-daemon.js --status
```

Requisitos para modo automático:
- `ANTHROPIC_API_KEY` en variables de entorno (para agentes Claude)
- `GEMINI_API_KEY` en variables de entorno (para agentes Gemini)
- Beads inicializado en el proyecto (`bd init`)

El daemon:
1. Monitorea Beads cada 5 segundos para tareas `ready`
2. Asigna cada tarea al modelo correcto (Claude o Gemini)
3. Ejecuta hasta 4 workers en paralelo
4. Cierra tareas automáticamente al completar

Configuración personalizada: copia `daemon/config.example.json` a `daemon/config.json`.

### Modo Híbrido

Puedes usar ambos modos simultáneamente:
- Daemon ejecutando tareas en background
- Tú trabajando manualmente en ventanas separadas
- Beads coordina el estado compartido

---

## Arquitectura de Convergencia

Capa opcional que coordina Claude y Gemini trabajando juntos. Sin activarla, los agentes funcionan igual — solo pierdes la coordinación multi-modelo.

```
╔═══════════════════════════════════════╗
║  ROLES — 11 skills (QUÉ hacen)       ║
╠═══════════════════════════════════════╣
║  INFRA — Beads + Worktrees (CÓMO)    ║
╠═══════════════════════════════════════╣
║  MODELOS — Claude + Gemini (QUIÉN)   ║
╚═══════════════════════════════════════╝
```

### Especialización por modelo

| Modelo | Agentes | Por qué |
|--------|---------|---------|
| **Opus** | lead-agent, security-hardener, project-auditor | Planning, seguridad, visión global |
| **Sonnet** | developer, perf, tester, devops, ui-specialist | Ejecución precisa, TDD, refactoring |
| **Cualquiera** | docs-writer, product-owner, agent-architect | Flexibles |

### Beads como nexo

Beads es el tracker de tareas que conecta a los agentes entre sí:

```
Lead Agent → bd create → tareas registradas
Lead Agent → bd ready → asigna waves
Developer → bd update → trabaja → bd close
Agent Architect → bd list --status closed → métricas
```

Sin Beads, cada agente trabaja aislado. Con Beads, comparten estado.

---

## Repositorios Externos

El instalador clona dos catálogos de skills adicionales:

| Repo | Contenido |
|------|-----------|
| [obra/superpowers](https://github.com/obra/superpowers) | Metodología: TDD, brainstorming, verificación |
| [sickn33/antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) | 600+ skills especializados |

**Nunca se instalan todos.** El agent-architect los analiza y recomienda solo lo relevante:

```
"Recomienda skills para este proyecto"  → Informe con recomendaciones
"Hay actualizaciones en los repos?"     → Comprueba nuevos commits
```

---

## Evolucionar el Sistema

Los agentes viven en este repo. Para mejorarlos:

```powershell
cd C:\www\agentes

# 1. Edita .agent/AGENTS.MD o .agent/skills/*/SKILL.md
#    (o pídele a un agente que lo haga)

# 2. Push
git add -A
git commit -m "feat: descripción del cambio"
git push

# 3. Re-instalar en proyectos que quieras actualizar
cd C:\www\mi-proyecto
powershell -ExecutionPolicy Bypass -File C:\www\agentes\install-agents.ps1
```

El instalador descarga del repo y sobreescribe AGENTS.MD y skills. Tu código, Beads, docs y worktrees nunca se tocan.

---

## Dev Observability

El devops-engineer configura automáticamente un `.dev-errors.log` que captura errores de servidor, cliente y build en formato universal. Solo en desarrollo.

```
"Lee .dev-errors.log y arregla los errores"
```

---

## Archivos del Repositorio

```
jeaw-agent-squad/
├── bootstrap.ps1        ← Infra global (una vez por máquina)
├── new-project.ps1      ← Setup de proyecto (una vez por proyecto)
├── install-agents.ps1   ← Instalador Windows
├── install-agents.sh    ← Instalador Linux/macOS
├── update.sh            ← Actualizador con versión
├── setup-repo.sh        ← Configuración inicial del repo (ya ejecutado)
├── VERSION              ← Versión actual
├── CHANGELOG.md         ← Historial de cambios
├── QUICKREF.md          ← Cheatsheet rápido
├── LICENSE              ← MIT
└── README.md            ← Este archivo
```

---

## Compatibilidad

El formato SKILL.md es estándar abierto. Funciona con:

| Herramienta | Ruta proyecto | Ruta global |
|-------------|---------------|-------------|
| Antigravity | `.agent/skills/` | `~/.gemini/antigravity/skills/` |
| Claude Code | `.claude/skills/` | `~/.claude/skills/` |
| Gemini CLI | `.gemini/skills/` | `~/.gemini/skills/` |
| Cursor | `.cursor/skills/` | `~/.cursor/skills/` |
| Codex | `.codex/skills/` | `~/.codex/skills/` |

---

## Idioma

Los agentes detectan automáticamente tu idioma. Si les hablas en español, responden en español. Si les hablas en inglés, responden en inglés. Términos técnicos siempre en inglés.
