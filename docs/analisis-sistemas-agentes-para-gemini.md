# Análisis Comparativo de Sistemas de Agentes IA

**Documento preparado para revisión por Gemini**
**Fecha:** 2026-02-05
**Autor del análisis:** Claude Opus 4.5
**Solicitante:** Javier (usuario)

---

## Índice

1. [Contexto y Objetivo](#1-contexto-y-objetivo)
2. [Proceso de Investigación](#2-proceso-de-investigación)
3. [Fuentes Consultadas](#3-fuentes-consultadas)
4. [Sistema Actual del Usuario](#4-sistema-actual-del-usuario)
5. [Sistema de Peter Steinberger (Steipete)](#5-sistema-de-peter-steinberger-steipete)
6. [Sistema Oficial de Anthropic](#6-sistema-oficial-de-anthropic)
7. [Equipos de Desarrollo Reales](#7-equipos-de-desarrollo-reales)
8. [Comparación de los 4 Enfoques](#8-comparación-de-los-4-enfoques)
9. [Análisis de Gaps y Redundancias](#9-análisis-de-gaps-y-redundancias)
10. [Propuesta de Rediseño Híbrido](#10-propuesta-de-rediseño-híbrido)
11. [Preguntas para Gemini](#11-preguntas-para-gemini)
12. [Anexos: Documentación Original](#12-anexos-documentación-original)

---

## 1. Contexto y Objetivo

### 1.1 Solicitud Original

El usuario tiene un sistema de agentes configurado en `c:\www\agentes` con 13 agentes especializados. Su pregunta inicial fue:

> "Mira la estructura de agentes que tengo. Estoy pensando si en la vida real es igual. Quiero ir revisándolo para verlo en profundidad."

Posteriormente añadió:

> "Como voy a usar principalmente Claude para mis desarrollos, creo que deberíamos también ver qué dice sobre todo esto la empresa creadora Anthropic. Su web, sus researchs y sus repos en GitHub como https://github.com/anthropics/skills"

Y finalmente:

> "¿Y esto coincide con la filosofía y el uso que le da Peter Steinberger?"

### 1.2 Objetivo del Análisis

Comparar 4 enfoques diferentes para organizar sistemas de agentes IA:

1. **Sistema actual del usuario** - 13 agentes especializados por rol
2. **Sistema de Steipete** - Minimalismo radical, "Just Talk To It"
3. **Sistema oficial de Anthropic** - Estándar formal con skills
4. **Equipos de desarrollo reales** - Cómo funcionan los equipos humanos

### 1.3 Proceso de Pensamiento

Mi razonamiento siguió estos pasos:

1. **Exploración inicial**: Usé un agente explorador para mapear la estructura completa del sistema del usuario
2. **Investigación Anthropic**: Busqué documentación oficial, cloné el repo `anthropics/skills`, leí la especificación en agentskills.io
3. **Investigación Steipete**: Busqué sus artículos en steipete.me, cloné sus repos `agent-rules` y `agent-scripts`
4. **Comparación con realidad**: Apliqué conocimiento sobre equipos de desarrollo de software reales
5. **Síntesis**: Identifiqué patrones, gaps, redundancias y propuse un híbrido

---

## 2. Proceso de Investigación

### 2.1 Herramientas Utilizadas

| Herramienta | Propósito |
|-------------|-----------|
| `Task (Explore)` | Explorar estructura del proyecto del usuario |
| `WebSearch` | Buscar documentación de Anthropic y artículos de Steipete |
| `WebFetch` | Obtener contenido de páginas específicas |
| `gh repo clone` | Clonar repositorios de GitHub |
| `Read` | Leer archivos de configuración y skills |

### 2.2 Secuencia de Investigación

```
1. Explorar c:\www\agentes\.agent\
   └── Encontré: AGENTS.MD + 13 skills en .agent/skills/

2. Buscar "Anthropic Claude agent architecture best practices"
   └── Encontré: Multi-agent research system, Agent Skills, Claude Code best practices

3. Clonar github.com/anthropics/skills
   └── Encontré: Spec, template, 17 skills de ejemplo

4. Leer agentskills.io/specification
   └── Encontré: Formato estándar SKILL.md con YAML frontmatter

5. Buscar "steipete Claude Code agents workflow"
   └── Encontré: Artículos en steipete.me, repos agent-rules y agent-scripts

6. Clonar github.com/steipete/agent-scripts
   └── Encontré: AGENTS.MD minimalista, 17 skills específicos de stack

7. Comparar con conocimiento de equipos reales
   └── Apliqué: Metodologías ágiles, roles T-shaped, prácticas de la industria
```

### 2.3 Decisiones Tomadas Durante el Análisis

| Decisión | Razonamiento |
|----------|--------------|
| Comparar 4 sistemas en lugar de 3 | El usuario preguntó "si en la vida real es igual", lo que requiere incluir equipos reales |
| Enfocar en estructura, no en contenido | El objetivo es arquitectura de agentes, no el código específico |
| Proponer híbrido en lugar de elegir uno | Cada sistema tiene fortalezas únicas que se complementan |

---

## 3. Fuentes Consultadas

### 3.1 Documentación Oficial de Anthropic

| Fuente | URL | Contenido Clave |
|--------|-----|-----------------|
| Multi-Agent Research System | https://www.anthropic.com/engineering/multi-agent-research-system | Patrón orchestrator-worker, 90% mejor que agente único |
| Agent Skills Announcement | https://www.anthropic.com/news/skills | Qué son skills, cómo funcionan |
| Agent Skills Spec | https://agentskills.io/specification | Formato SKILL.md, YAML frontmatter requerido |
| Skills Repository | https://github.com/anthropics/skills | 17 skills de ejemplo, template, spec |
| Skill Creator Guide | anthropics/skills/skills/skill-creator/SKILL.md | Mejores prácticas para crear skills |

### 3.2 Artículos de Peter Steinberger

| Fuente | URL | Contenido Clave |
|--------|-----|-----------------|
| Just Talk To It | https://steipete.me/posts/just-talk-to-it | Filosofía minimalista, anti-patrones |
| My Current AI Dev Workflow | https://steipete.me/posts/2025/optimal-ai-development-workflow | Setup con Ghostty, 1-4 agentes paralelos |
| agent-scripts repo | https://github.com/steipete/agent-scripts | AGENTS.MD actual, skills por stack |

### 3.3 Otras Fuentes

| Fuente | Contenido |
|--------|-----------|
| 2026 Agentic Coding Trends Report | Tendencias en desarrollo con agentes |
| ByteByteGo: How Anthropic Built Multi-Agent | Análisis técnico del sistema |

---

## 4. Sistema Actual del Usuario

### 4.1 Estructura de Archivos

```
c:\www\agentes\
├── .agent/                          ← FUENTE CANÓNICA
│   ├── AGENTS.MD                    ← Documento maestro (10 Iron Laws)
│   └── skills/
│       ├── accessibility-auditor/SKILL.md
│       ├── agent-architect/SKILL.md
│       ├── code-reviewer/SKILL.md
│       ├── developer/SKILL.md
│       ├── devops-engineer/SKILL.md
│       ├── docs-writer/SKILL.md
│       ├── orchestrator/SKILL.md
│       ├── performance-optimizer/SKILL.md
│       ├── project-auditor/SKILL.md
│       ├── security-hardener/SKILL.md
│       ├── systematic-debugger/SKILL.md
│       ├── tech-lead/SKILL.md
│       └── test-engineer/SKILL.md
│
├── .claude/                         ← Integración Claude Code
│   ├── settings.local.json
│   └── skills -> .agent/skills      ← Symlink
│
└── .external-refs/
    └── superpowers/                 ← Repo externo de skills
```

### 4.2 Los 13 Agentes

| # | Agente | Triggers | Responsabilidad |
|---|--------|----------|-----------------|
| 1 | project-auditor | audit, review, analyze | Auditoría técnica inicial |
| 2 | tech-lead | plan, sprint, prioritize | Planificación y delegación |
| 3 | developer | implement, fix, code | Escribir código |
| 4 | security-hardener | security, vulnerability | Seguridad OWASP |
| 5 | performance-optimizer | performance, slow | Optimización |
| 6 | test-engineer | test, coverage, TDD | Testing |
| 7 | docs-writer | document, readme | Documentación |
| 8 | devops-engineer | deploy, CI/CD | Infraestructura |
| 9 | accessibility-auditor | a11y, WCAG | Accesibilidad |
| 10 | agent-architect | evaluate agents | Meta-agente |
| 11 | orchestrator | parallel, dispatch | Coordinación |
| 12 | code-reviewer | PR review | Revisión de código |
| 13 | systematic-debugger | bug, debug, error | Debugging |

### 4.3 Iron Laws (10 Reglas)

```
1. IDENTIFY    → Iniciar con [emoji agent-name] -- reason
2. SKILL FIRST → Leer SKILL.md antes de responder
3. VERIFY      → No reclamar sin evidencia verificada
4. READ FIRST  → Leer archivos antes de modificar
5. MAX 500 LOC → Dividir archivos grandes
6. NO DESTROY  → Sin ops git destructivas
7. CONV COMMIT → Conventional commits
8. USER LANG   → Responder en idioma del usuario
9. TESTS PASS  → Tests deben pasar antes de merge
10. NO SUPPRESS → No suprimir warnings, arreglar root cause
```

### 4.4 Características Notables

**Fortalezas:**
- Cobertura completa de roles de desarrollo
- Security-hardener dedicado (raro en otros sistemas)
- Iron Laws claras y verificables
- Enforcement de TDD en test-engineer
- Transparencia con identificación de agente

**Debilidades identificadas:**
- Sin YAML frontmatter (no compatible con estándar Anthropic)
- Roles que son actividades: code-reviewer, systematic-debugger
- Orquestación duplicada: tech-lead + orchestrator
- Sin escalado dinámico (13 agentes fijos)
- Falta Product Owner (quién define QUÉ construir)

---

## 5. Sistema de Peter Steinberger (Steipete)

### 5.1 Filosofía Central

> "Just Talk To It" — La esencia es la simplicidad. Comunicación directa, sin elaboradas charadas.

**Principios:**
- Telegraph style: "noun-phrases ok; drop grammar; min tokens"
- Claude ya es muy inteligente, solo añade lo que NO sabe
- Evaluar "blast radius" (impacto) de cada cambio
- CLI tools sobre MCPs ("clutters context")
- Screenshots para contexto UI ("increíblemente efectivo")

### 5.2 AGENTS.MD de Steipete (Extracto)

```markdown
# AGENTS.MD

Peter owns this. Start: say hi + 1 motivating line.
Work style: telegraph; noun-phrases ok; drop grammar; min tokens.

## Agent Protocol
- Files: repo or `~/Projects/agent-scripts`.
- PRs: use `gh pr view/diff` (no URLs).
- Keep files <~500 LOC; split/refactor as needed.
- Commits: Conventional Commits.
- Prefer end-to-end verify; if blocked, say what's missing.

## Git
- Safe by default: `git status/diff/log`. Push only when user asks.
- Destructive ops forbidden unless explicit.
- No amend unless asked.

## Critical Thinking
- Fix root cause (not band-aid).
- Unsure: read more code; if still stuck, ask w/ short options.
```

**Tamaño total: ~170 líneas** (vs ~400+ del usuario)

### 5.3 Skills de Steipete

```
skills/
├── 1password/
├── brave-search/
├── create-cli/
├── domain-dns-ops/
├── frontend-design/
├── instruments-profiling/
├── markdown-converter/
├── nano-banana-pro/
├── native-app-performance/
├── openai-image-gen/
├── oracle/                    ← "2nd model review"
├── swift-concurrency-expert/
├── swiftui-liquid-glass/
├── swiftui-performance-audit/
├── swiftui-view-refactor/
└── video-transcript-downloader/
```

**Patrón:** Skills por **stack/herramienta**, no por **rol**.

### 5.4 Herramientas Custom

| Herramienta | Propósito |
|-------------|-----------|
| `committer` | Helper para commits (stages + message) |
| `docs-list` | Lista docs/ con frontmatter |
| `browser-tools` | Chrome DevTools automation |
| `oracle` | Consultar 2do modelo cuando stuck |
| `bird` | CLI para X/Twitter |
| `peekaboo` | Screen capture/click |

### 5.5 Anti-patrones que Evita

```
❌ RAG innecesario
❌ Sub-agentes complejos
❌ Prompts sobre-documentados con "agentes IA especializados"
❌ Worktrees/PRs por cambio (más lento)
❌ MCPs ("clutters context")
❌ Wrappers de SDK (soluciones temporales)
❌ "AI slop" en UI
```

### 5.6 Modelo de Trabajo

```
Setup: 3-8 instancias en paralelo (tmux)
Prompts: 1-2 oraciones (Claude lee el código)
Refactoring: ~20% del tiempo
Tests: En el mismo contexto que la implementación
Modelos: Haiku (rápido) vs Opus (review)
```

---

## 6. Sistema Oficial de Anthropic

### 6.1 Agent Skills Specification

**Fuente:** https://agentskills.io/specification

#### Estructura Requerida

```
skill-name/
├── SKILL.md          # Requerido
├── scripts/          # Opcional: código ejecutable
├── references/       # Opcional: documentación adicional
└── assets/           # Opcional: recursos estáticos
```

#### Formato SKILL.md

```markdown
---
name: skill-name
description: A description of what this skill does and when to use it.
---

# Skill Instructions

[Contenido markdown con instrucciones]
```

#### Campos del Frontmatter

| Campo | Requerido | Restricciones |
|-------|-----------|---------------|
| `name` | Sí | Max 64 chars, lowercase, hyphens |
| `description` | Sí | Max 1024 chars, describe qué hace y cuándo usarlo |
| `license` | No | Nombre de licencia o referencia a archivo |
| `compatibility` | No | Requisitos de entorno |
| `metadata` | No | Key-value adicional |

### 6.2 Progressive Disclosure

Anthropic recomienda un sistema de 3 niveles:

```
1. Metadata (~100 tokens)     → Siempre cargado (name + description)
2. SKILL.md body (<5000 tok)  → Cuando skill se activa
3. References (ilimitado)     → Solo cuando necesario
```

**Regla:** SKILL.md < 500 líneas. Si excede, mover a `references/`.

### 6.3 Multi-Agent Research System

**Fuente:** https://www.anthropic.com/engineering/multi-agent-research-system

#### Arquitectura

```
┌─────────────────────────────────────────────────────────┐
│                    LEAD AGENT (Opus)                    │
│  • Analiza query                                        │
│  • Desarrolla estrategia                                │
│  • Crea subagentes                                      │
│  • Sintetiza resultados                                 │
└─────────────────────────────────────────────────────────┘
                            │
            ┌───────────────┼───────────────┐
            ▼               ▼               ▼
    ┌───────────┐   ┌───────────┐   ┌───────────┐
    │ Subagent  │   │ Subagent  │   │ Subagent  │
    │ (Sonnet)  │   │ (Sonnet)  │   │ (Sonnet)  │
    └───────────┘   └───────────┘   └───────────┘
```

#### Resultados

- Multi-agente superó a Claude Opus único en **90.2%**
- Usa **15x más tokens** que chat (requiere tareas de alto valor)
- Reducción de tiempo hasta **90%** para queries complejas

#### Reglas de Escalado

| Complejidad | Agentes | Tool Calls |
|-------------|---------|------------|
| Simple (fact-finding) | 1 | 3-10 |
| Media (comparaciones) | 2-4 | 10-15 cada uno |
| Compleja (research) | 10+ | Responsabilidades divididas |

#### 8 Principios de Prompt Engineering

1. **Pensar como agentes** - Simular para observar fallos
2. **Enseñar delegación** - Descripciones detalladas previenen duplicación
3. **Escalar según complejidad** - Reglas explícitas
4. **Diseño crítico de herramientas** - Descripciones claras
5. **Auto-mejora** - Claude puede diagnosticar fallos de prompt
6. **Estrategia amplia-estrecha** - Iniciar amplio, precisar según hallazgos
7. **Extended thinking** - Scratchpad controlable para planificación
8. **Paralelización** - Crítica para velocidad

### 6.4 Skills de Ejemplo (anthropics/skills)

```
skills/
├── algorithmic-art/
├── brand-guidelines/
├── canvas-design/
├── doc-coauthoring/
├── docx/              ← Source-available (producción)
├── frontend-design/
├── internal-comms/
├── mcp-builder/
├── pdf/               ← Source-available (producción)
├── pptx/              ← Source-available (producción)
├── skill-creator/
├── slack-gif-creator/
├── theme-factory/
├── webapp-testing/
├── web-artifacts-builder/
└── xlsx/              ← Source-available (producción)
```

### 6.5 Skill Creator Guidelines

**Principio central:**
> "Claude ya es muy inteligente. Solo añade contexto que NO tiene. Desafía cada pieza de información: '¿Claude realmente necesita esta explicación?'"

**Grados de libertad:**
- **Alta libertad** (instrucciones texto): Múltiples enfoques válidos
- **Media libertad** (pseudocódigo): Patrón preferido con variación
- **Baja libertad** (scripts específicos): Operaciones frágiles

---

## 7. Equipos de Desarrollo Reales

### 7.1 Roles por Tamaño de Empresa

| Tamaño | Roles Típicos |
|--------|---------------|
| 1-3 personas | Fullstack generalist (hace todo) |
| 4-10 personas | Lead, 2-3 devs, QA, DevOps |
| 10-30 personas | Especialistas emergiendo |
| 30+ personas | Equipos dedicados por área |

### 7.2 Concepto T-Shaped

En equipos reales, las personas son **T-shaped**:
- **Horizontal:** Capacidad básica en múltiples áreas
- **Vertical:** Profundidad en 1-2 especialidades

```
T-SHAPED:                       I-SHAPED (sistema del usuario):
┌─────────────────┐                    │
│ Capacidad básica│                    │
│   en TODO       │                    │
└────────┬────────┘                    │
         │                             │
         │                             │
         ▼                             ▼
   Profundidad                   Solo su
   en 1-2 áreas                  especialidad
```

### 7.3 Flujo de Trabajo Real

```
Product Owner → Planning (equipo) → Sprint → [Dev + Test + Review] → Deploy
      ↑                                                                  │
      └──────────────────────── Feedback ────────────────────────────────┘
```

**Características:**
- PO define QUÉ construir (negocio)
- Tech Lead define CÓMO (técnico)
- Testing es CONTINUO, no fase separada
- Code review es actividad de PEERS, no rol dedicado
- Comunicación DIRECTA y constante

### 7.4 Lo que Falta en Sistemas de Agentes

| Necesidad Real | Usuario | Steipete | Anthropic |
|----------------|---------|----------|-----------|
| Product Owner | ❌ | ❌ | ❌ |
| Designer/UX | ❌ | ✅ frontend-design | ✅ frontend-design |
| Feedback loops | ⚠️ | ✅ | ✅ |
| Testing continuo | ❌ Fase separada | ⚠️ | ⚠️ |
| Conocimiento tácito | ❌ | ❌ | ⚠️ Memoria |

### 7.5 Roles vs Actividades

**En equipos reales, esto NO son roles:**

| Actividad | En equipos reales | En sistema del usuario |
|-----------|-------------------|------------------------|
| Code Review | Todos los devs lo hacen | Agente dedicado ❌ |
| Debugging | Habilidad de todo dev | Agente dedicado ❌ |
| Documentar | Responsabilidad compartida | Agente dedicado ⚠️ |

---

## 8. Comparación de los 4 Enfoques

### 8.1 Filosofía

| | Usuario | Steipete | Anthropic | Equipos Reales |
|---|---|---|---|---|
| **Metáfora** | Empresa con departamentos | Freelancer con tools | Orquesta con director | Equipo ágil |
| **Principio** | Cobertura completa | "Min tokens" | Progressive disclosure | Colaboración T-shaped |
| **Complejidad** | Alta (13 fijos) | Baja (conversación) | Media (dinámico) | Variable |

### 8.2 Estructura

| Aspecto | Usuario | Steipete | Anthropic | Equipos Reales |
|---------|---------|----------|-----------|----------------|
| **Archivo principal** | AGENTS.MD + 13 SKILL.md | AGENTS.MD único | SKILL.md con YAML | N/A |
| **Tamaño** | ~2000+ LOC total | ~170 LOC | ~500 LOC por skill | N/A |
| **Frontmatter YAML** | ❌ No | ❌ No | ✅ Requerido | N/A |
| **Progressive disclosure** | ❌ No | ❌ No | ✅ references/ | N/A |
| **Scripts reutilizables** | ❌ No | ✅ Sí | ✅ Sí | N/A |

### 8.3 Roles/Agentes

| Aspecto | Usuario | Steipete | Anthropic | Equipos Reales |
|---------|---------|----------|-----------|----------------|
| **Cantidad** | 13 fijos | 17 por stack | Dinámico | 5-8 típico |
| **Tipo** | Por rol genérico | Por herramienta | Por tarea | T-shaped |
| **Activación** | Manual | Conversacional | Automática | N/A |
| **Escalado** | Fijo | Manual | Dinámico | Por proyecto |

### 8.4 Cobertura de Roles

| Rol | Usuario | Steipete | Anthropic | Real |
|-----|---------|----------|-----------|------|
| Developer | ✅ | Conversación | Skills | ✅ |
| Tech Lead | ✅ | Conversación | Lead Agent | ✅ |
| Code Reviewer | ✅ Agente | ❌ | ❌ | **Actividad** |
| Debugger | ✅ Agente | ❌ | ❌ | **Habilidad** |
| QA/Tester | ✅ | ❌ | webapp-testing | ⚠️ |
| Security | ✅ | ❌ | ❌ | ⚠️ Grande |
| Performance | ✅ | ✅ Stack | ❌ | ⚠️ Grande |
| DevOps | ✅ | ⚠️ | ❌ | ✅ |
| Docs | ✅ | ✅ | ✅ | ⚠️ Compartido |
| **Product Owner** | ❌ | ❌ | ❌ | **✅ Crítico** |
| Designer/UX | ❌ | ✅ | ✅ | ✅ |

### 8.5 Orquestación

| Aspecto | Usuario | Steipete | Anthropic | Equipos Reales |
|---------|---------|----------|-----------|----------------|
| **Patrón** | tech-lead + orchestrator | tmux manual | Lead → Workers | PM → Lead → Team |
| **Comunicación** | Archivos | Conversación | Memoria + handoffs | Directa |
| **Feedback** | Unidireccional | Bidireccional | Bidireccional | Constante |
| **Modelo** | No diferenciado | Haiku/Opus | Opus/Sonnet | N/A |

### 8.6 Testing

| Aspecto | Usuario | Steipete | Anthropic | Equipos Reales |
|---------|---------|----------|-----------|----------------|
| **Cuándo** | Fase separada | No especifica | Post-impl | **Continuo** |
| **Quién** | Agente dedicado | Developer | Developer | Dev + QA |
| **Integración** | Separado | Integrado | Integrado | **Integrado** |

### 8.7 Anti-patrones

| Anti-patrón | Usuario | Steipete | Anthropic | Real |
|-------------|---------|----------|-----------|------|
| Roles como actividades | ❌ Tiene 2 | ✅ No tiene | ✅ No tiene | ✅ Integrado |
| Sin stakeholder negocio | ❌ Falta PO | ❌ | ❌ | ✅ PO |
| Testing al final | ❌ | — | — | ✅ Continuo |
| Especialización excesiva | ⚠️ 13 I-shaped | ✅ Flexible | ✅ Dinámico | ✅ T-shaped |
| Sin feedback loops | ⚠️ | ✅ | ✅ | ✅ |

---

## 9. Análisis de Gaps y Redundancias

### 9.1 Redundancias en Sistema del Usuario

| Redundancia | Análisis |
|-------------|----------|
| `code-reviewer` | En equipos reales es actividad del developer, no rol |
| `systematic-debugger` | En equipos reales es habilidad del developer, no rol |
| `tech-lead` + `orchestrator` | Funciones similares de coordinación |
| `agent-architect` | Meta-nivel, solo para mantenimiento del sistema |

### 9.2 Gaps Críticos

| Gap | Impacto |
|-----|---------|
| Sin YAML frontmatter | Skills no se activan automáticamente |
| Sin Product Owner | Nadie define QUÉ construir (solo CÓMO) |
| Sin escalado dinámico | 13 agentes siempre, aunque tarea sea simple |
| Testing como fase | No es continuo como en metodologías ágiles |
| Sin modelo diferenciado | No optimiza costos (Haiku vs Opus) |

### 9.3 Fortalezas Únicas del Usuario

| Fortaleza | Por qué mantenerla |
|-----------|-------------------|
| `security-hardener` | Ni Steipete ni Anthropic lo tienen |
| `test-engineer` con TDD | Enforcement importante |
| Iron Laws verificables | Claridad y consistencia |
| `devops-engineer` | Estándar en equipos modernos |
| Transparencia (identificación) | Útil para debugging |

### 9.4 Lo que Falta de Steipete

| Elemento | Beneficio |
|----------|-----------|
| Estilo telegráfico | Menos tokens, más eficiente |
| Modelo diferenciado | Haiku para rápido, Opus para review |
| Scripts reutilizables | `committer`, `docs-list` |
| `oracle` (2nd model) | Segunda opinión cuando stuck |

### 9.5 Lo que Falta de Anthropic

| Elemento | Beneficio |
|----------|-----------|
| YAML frontmatter | Activación automática de skills |
| Progressive disclosure | `references/` para contenido largo |
| Escalado dinámico | 1 agente para simple, 10+ para complejo |
| Memoria persistente | Contexto entre sesiones |

---

## 10. Propuesta de Rediseño Híbrido

### 10.1 Estructura Propuesta

```
.agent/
├── AGENTS.MD                    ← Estilo Steipete (~150 líneas)
│
├── skills/
│   ├── core/                    ← Siempre activos (de Equipos Reales)
│   │   ├── lead-agent/          (fusiona tech-lead + orchestrator)
│   │   │   └── SKILL.md         (con YAML frontmatter de Anthropic)
│   │   └── developer/           (fusiona + review + debug)
│   │       └── SKILL.md
│   │
│   ├── specialists/             ← Por demanda (del Usuario)
│   │   ├── security-hardener/
│   │   ├── test-engineer/       (pero integrado, no fase)
│   │   ├── performance-optimizer/
│   │   └── devops-engineer/
│   │
│   └── stack/                   ← Por tecnología (de Steipete)
│       └── [tecnología]/
│
├── references/                  ← De Anthropic
│   ├── debugging-guide.md
│   ├── code-review-checklist.md
│   └── security-checklist.md
│
└── scripts/                     ← De Steipete
    ├── committer
    └── docs-list
```

### 10.2 Nuevo AGENTS.MD (Estilo Híbrido)

```markdown
# AGENTS.MD

Work style: telegraph; min tokens; drop filler.

## Iron Laws
1. IDENTIFY → [emoji agent] -- reason
2. READ FIRST → No edit without read
3. VERIFY → Fresh evidence before claim
4. <500 LOC → Split large files
5. NO DESTROY → No destructive git ops

## Model Selection
- Quick tasks: Haiku
- Implementation: Sonnet
- Architecture/Review: Opus

## Scaling Rules
- Simple (1 file, clear fix): 1 agent, direct action
- Medium (feature, 2-5 files): lead-agent + 1-2 specialists
- Complex (architecture, 10+ files): lead-agent + multiple parallel

## Core Agents (always available)
- lead-agent: planning, delegation, coordination, synthesis
- developer: code, review, debug (T-shaped, all-in-one)

## Specialists (on-demand activation)
- security-hardener: OWASP, vulnerabilities, hardening
- test-engineer: TDD, coverage, e2e (integrated, not phase)
- performance-optimizer: metrics, profiling, optimization
- devops-engineer: CI/CD, infra, observability

## Stack Skills
- Load from skills/stack/ based on project detection

## Tools
- CLI over MCPs (less context pollution)
- `gh` for all GitHub ops
- `committer` for commits
- Conventional commits required

## References
- See references/ for detailed guides
- Load only when needed (progressive disclosure)
```

### 10.3 Roles Finales (8 vs 13)

| Rol | Origen | Justificación |
|-----|--------|---------------|
| `lead-agent` | Fusión | Como equipos reales: 1 coordinador |
| `developer` | Fusión | T-shaped: code + review + debug |
| `test-engineer` | Usuario | Integrado en desarrollo, no fase |
| `security-hardener` | Usuario | Especialista único (fortaleza) |
| `performance-optimizer` | Usuario | Por demanda |
| `devops-engineer` | Usuario | Estándar moderno |
| `docs-writer` | Usuario | Automático post-sprint |
| `project-auditor` | Usuario | Solo inicial o periódico |

### 10.4 Eliminados y Por Qué

| Eliminado | Razón |
|-----------|-------|
| `code-reviewer` | Actividad del developer (equipos reales) |
| `systematic-debugger` | Habilidad del developer (equipos reales) |
| `orchestrator` | Fusionado en lead-agent |
| `agent-architect` | Herramienta de mantenimiento, no agente |
| `accessibility-auditor` | On-demand, no permanente |

### 10.5 Añadido Futuro (Consideración)

| Rol | Por qué considerarlo |
|-----|---------------------|
| `product-owner` | Define QUÉ construir (crítico en equipos reales) |

---

## 11. Preguntas para Gemini

### 11.1 Sobre la Comparación

1. ¿Estás de acuerdo con la caracterización de cada sistema? ¿Hay matices que se me escapan?

2. ¿El mapeo entre roles de agentes y roles de equipos reales es preciso? ¿Hay roles de equipos reales que no he considerado?

3. ¿La crítica de que `code-reviewer` y `systematic-debugger` son "actividades, no roles" es válida? ¿O hay argumentos para mantenerlos separados en sistemas de agentes?

### 11.2 Sobre las Recomendaciones

4. ¿La propuesta híbrida es coherente? ¿Hay contradicciones entre los elementos tomados de cada fuente?

5. ¿8 agentes es el número correcto, o debería ser más/menos?

6. ¿El escalado dinámico (1 agente para simple, 10+ para complejo) es aplicable a desarrollo de software general, o solo a research como en el paper de Anthropic?

### 11.3 Sobre Gaps

7. ¿Es crítico añadir un `product-owner` agent, o esa función la cumple el usuario humano?

8. ¿Qué opinas del rechazo de Steipete a MCPs? ¿Es válido para todos los casos o solo para su workflow específico?

9. ¿El testing debería ser agente separado o integrado en developer? El sistema del usuario lo tiene separado, pero equipos reales lo integran.

### 11.4 Sobre Implementación

10. Si tuvieras que elegir UN solo cambio de alta prioridad para el sistema del usuario, ¿cuál sería?

11. ¿Hay riesgos en la migración que no he identificado?

12. ¿Conoces otros sistemas de agentes o filosofías que debería considerar en esta comparación?

---

## 12. Anexos: Documentación Original

### 12.1 AGENTS.MD del Usuario (Extracto)

```markdown
# AGENTS.MD - Agent Team Instructions

## Iron Laws (NON-NEGOTIABLE)

1. **IDENTIFY** - Start responses with `[emoji agent-name] -- brief reason`
2. **SKILL FIRST** - Read `.agent/skills/{agent}/SKILL.md` BEFORE responding
3. **VERIFY** - Don't claim completion without verified evidence
4. **READ FIRST** - Always read complete files before modifying
5. **MAX 500 LOC** - Split files exceeding ~500 lines
6. **NO DESTROY** - No destructive git operations without explicit permission
7. **CONV COMMIT** - Use conventional commits
8. **USER LANG** - Respond in user's language (code in English)
9. **TESTS PASS** - Tests must pass before merge/PR
10. **NO SUPPRESS** - Never suppress linter warnings, fix root cause

## Verification Protocol

BEFORE claiming completion:
1. IDENTIFY what command proves the claim
2. RUN the command (fresh, complete)
3. READ full output, check exit code
4. ONLY THEN make the claim with evidence
```

### 12.2 AGENTS.MD de Steipete (Completo)

Ver sección 5.2 de este documento.

### 12.3 Especificación Anthropic (Resumen)

Ver sección 6.1 de este documento.

### 12.4 URLs de Referencia

**Anthropic:**
- https://www.anthropic.com/engineering/multi-agent-research-system
- https://agentskills.io/specification
- https://github.com/anthropics/skills

**Steipete:**
- https://steipete.me/posts/just-talk-to-it
- https://steipete.me/posts/2025/optimal-ai-development-workflow
- https://github.com/steipete/agent-scripts

---

## Nota Final

Este documento fue generado por Claude Opus 4.5 el 2026-02-05 a solicitud del usuario Javier. El objetivo es que Gemini revise el análisis, valide las conclusiones, identifique gaps en el razonamiento, y proporcione una segunda opinión sobre la propuesta de rediseño híbrido.

El proceso completo de investigación tomó múltiples búsquedas web, clonación de repositorios, lectura de documentación, y síntesis comparativa. Todas las fuentes están citadas y los extractos de código son textuales de las fuentes originales.

---

*Fin del documento*
