# Comparación de 5 Visiones: Sistemas de Agentes

**Objetivo:** Comparar sistemáticamente las 5 visiones para tomar decisiones informadas.
**Fecha:** 2026-02-05
**Estado:** ✅ DECISIONES COMPLETADAS

---

## Las 5 Visiones

| # | Visión | Descripción |
|---|--------|-------------|
| 1 | **Tu Sistema Actual** | 13 agentes especializados, Beads, Worktrees, Daemon |
| 2 | **Steipete** | Minimalismo, "Just Talk To It", tmux manual |
| 3 | **Anthropic** | Skills formales, Lead+Subagents, escalado dinámico |
| 4 | **Equipos Reales** | Roles T-shaped, comunicación continua, Agile |
| 5 | **Sistema Final Aprobado** | 11 agentes (7 core + 4 on-demand), progressive disclosure |

---

## PARTE 1: Estructura de Agentes

### 1.1 Número de Agentes

| Visión | Cantidad | Justificación |
|--------|----------|---------------|
| Tu Sistema Actual | 13 fijos | Cobertura completa de roles |
| Steipete | 17 por stack | Específicos a tecnología (Swift, SwiftUI) |
| Anthropic | Variable | Skills por tarea, carga dinámica |
| Equipos Reales | 5-8 típico | Personas T-shaped |
| **Nuevo Propuesto** | **8** | Balance cobertura vs complejidad |

### 1.2 Organización de Agentes

| Visión | Estructura | Tiers/Categorías |
|--------|------------|------------------|
| Tu Sistema Actual | Plana (todos iguales) | No hay tiers |
| Steipete | Por stack/herramienta | swift-*, swiftui-*, tools |
| Anthropic | Por tarea/dominio | Creative, Development, Enterprise, Document |
| Equipos Reales | Jerárquica | Lead → Seniors → Juniors |
| **Nuevo Propuesto** | **3 Tiers** | **Core (3) → Specialists (4) → On-demand (2)** |

### 1.3 Detalle del Sistema Final Aprobado (11 agentes)

```
DEFAULT (Sin skill específico):
└── 💬 assistant        → Confirmación visual del sistema activo

CORE (7 agentes - Siempre disponibles):
├── 🎯 lead-agent              → Planning + Orchestration (fusión tech-lead + orchestrator)
├── 💻 developer               → Implementation + Debug Mode + Review Mode
├── 🔒 security-hardener       → Seguridad, OWASP, vulnerabilidades
├── ⚡ performance-optimizer   → Rendimiento, profiling, optimización
├── 🧪 test-engineer           → TDD, coverage, e2e
├── 🚀 devops-engineer         → CI/CD, Docker, infra
└── 🎨 ui-specialist           → Frontend + UX + Accesibilidad (nuevo)

ON-DEMAND (4 agentes - Cuando se invocan):
├── 📝 docs-writer       → Documentación (post-sprint, releases)
├── 🎭 product-owner     → Requirements, MVP, user stories (cuando se llama)
├── 🔍 project-auditor   → Auditoría completa (inicio, cada N sprints)
└── 🧬 agent-architect   → Evaluación de skills (retrospectivas)
```

**Agentes eliminados/fusionados:**
- ~~tech-lead~~ → fusionado en lead-agent
- ~~orchestrator~~ → fusionado en lead-agent
- ~~systematic-debugger~~ → Debug Mode en developer
- ~~code-reviewer~~ → Review Mode en developer
- ~~accessibility-auditor~~ → fusionado en ui-specialist

---

## PARTE 2: Roles y Responsabilidades

### 2.1 Tabla Comparativa de Roles

| Rol/Función | Tu Sistema | Steipete | Anthropic | Equipos Reales | Nuevo Propuesto |
|-------------|------------|----------|-----------|----------------|-----------------|
| **Define QUÉ construir** | ❌ No tiene | ❌ Usuario | ❌ Usuario | ✅ Product Owner | ✅ product-owner |
| **Planifica CÓMO** | tech-lead | Conversación | Lead Agent | Tech Lead | lead-agent |
| **Coordina paralelo** | orchestrator | tmux manual | Lead Agent | Scrum Master | lead-agent (fusionado) |
| **Implementa código** | developer | Conversación | Skills | Developers | developer |
| **Debugging** | systematic-debugger | Conversación | — | Developer (actividad) | developer (modo) |
| **Code Review** | code-reviewer | Conversación | — | Peers (actividad) | developer (modo) |
| **Seguridad** | security-hardener | ❌ No tiene | ❌ No tiene | ⚠️ Especialista | security-hardener |
| **Performance** | performance-optimizer | Stack-specific | ❌ No tiene | ⚠️ Especialista | performance-optimizer |
| **Testing** | test-engineer | ❌ Implícito | webapp-testing | QA + Devs | test-engineer |
| **DevOps** | devops-engineer | ❌ Implícito | ❌ No tiene | DevOps/SRE | devops-engineer |
| **Documentación** | docs-writer | markdown-converter | brand-guidelines | ⚠️ Compartido | docs-writer |
| **Auditoría** | project-auditor | ❌ No tiene | ❌ No tiene | Consultor externo | project-auditor |
| **UX/Design** | ❌ No tiene | frontend-design | frontend-design | Designer | ❌ No incluido |
| **Meta-agente** | agent-architect | ❌ No tiene | skill-creator | ❌ No existe | ❌ Eliminado (herramienta) |

### 2.2 Análisis de Decisiones de Roles

#### DECISIÓN 1: ¿Incluir Product Owner?

| Visión | Posición | Argumento |
|--------|----------|-----------|
| Tu Sistema | No tiene | Usuario define requisitos |
| Steipete | No tiene | "Just talk to it" |
| Anthropic | No tiene | Usuario provee query |
| Equipos Reales | **Crítico** | Define backlog, prioriza, acepta entregables |
| **Nuevo Propuesto** | **Sí, pero condicional** | Para features nuevas, no para bugs |

**Pregunta para decidir:** ¿Quieres que el sistema te ayude a clarificar requisitos antes de codificar, o prefieres definirlos tú siempre?

```
Opción A: PO siempre activo primero
  Usuario → PO → Lead → Specialists

Opción B: PO solo para features nuevas (RECOMENDADO)
  Feature nueva  → PO → Lead → Specialists
  Bug/Refactor   → Lead → Developer directo

Opción C: Sin PO (usuario define todo)
  Usuario → Lead → Specialists
```

**Tu decisión:** _______________

---

#### DECISIÓN 2: ¿Fusionar Debugging y Review en Developer?

| Visión | Posición | Argumento |
|--------|----------|-----------|
| Tu Sistema | Agentes separados | Especialización |
| Steipete | No existen | Conversación directa |
| Anthropic | No existen | Skills por tarea |
| Equipos Reales | **Actividades del dev** | Senior dev hace 80% de su propio debug/review |
| **Nuevo Propuesto** | **Fusionados como "modos"** | Developer con Implementation/Debug/Review modes |

**Argumento de Gemini:**
> "El coste de cambio de contexto (files, logs, historial) supera el beneficio en el 90% de los casos. Es mejor instruir al Developer para que cambie de 'Sombrero' que cambiar de 'Agente'."

**Pregunta para decidir:** ¿Prefieres agentes separados para debug/review, o modos dentro del developer?

```
Opción A: Mantener separados (tu sistema actual)
  Bug → systematic-debugger
  Review → code-reviewer

Opción B: Fusionar como modos (RECOMENDADO)
  Bug → developer (Debug Mode) → lee references/debugging-guide.md
  Review → developer (Review Mode) → lee references/code-review-checklist.md

Opción C: Eliminar completamente (estilo Steipete)
  Todo en conversación directa, sin estructura
```

**Tu decisión:** _______________

---

#### DECISIÓN 3: ¿Fusionar Tech-Lead y Orchestrator?

| Visión | Posición | Argumento |
|--------|----------|-----------|
| Tu Sistema | Separados | tech-lead planifica, orchestrator ejecuta paralelo |
| Steipete | No existen formalmente | Usuario coordina manualmente |
| Anthropic | **Uno solo: Lead Agent** | Planifica Y coordina subagentes |
| Equipos Reales | **Tech Lead hace ambos** | Planifica sprint Y asigna tareas |
| **Nuevo Propuesto** | **Fusionados en lead-agent** | Strategy (planning) + Tactics (dispatch) |

**Pregunta para decidir:** ¿Tiene sentido separar planificación de coordinación?

```
Opción A: Mantener separados
  Planificación → tech-lead
  Ejecución paralela → orchestrator

Opción B: Fusionar (RECOMENDADO)
  Todo → lead-agent (planifica + coordina + valida)
```

**Tu decisión:** _______________

---

## PARTE 3: Comunicación y Contexto

### 3.1 Tabla Comparativa

| Aspecto | Tu Sistema | Steipete | Anthropic | Equipos Reales | Nuevo Propuesto |
|---------|------------|----------|-----------|----------------|-----------------|
| **Medio de comunicación** | Archivos (docs/plans/) | Conversación | Memoria + Handoffs | Slack, Meetings | Archivos + Referencias |
| **Contexto entre agentes** | Se pierde | Se mantiene (1 conversación) | Memoria persistente | Conocimiento tácito | Referencias compartidas |
| **Feedback loops** | Unidireccional | Bidireccional | Bidireccional | Constante | Bidireccional |
| **Tamaño de instrucciones** | Detallado (~200-400 LOC) | Telegráfico (~170 LOC total) | Medio (~500 LOC max) | Variable | ~150 LOC + referencias |

### 3.2 Análisis de Decisiones de Contexto

#### DECISIÓN 4: ¿Estilo de instrucciones?

| Visión | Estilo | Ejemplo |
|--------|--------|---------|
| Tu Sistema | Detallado | Instrucciones completas en cada SKILL.md |
| Steipete | **Telegráfico** | "Work style: telegraph; drop grammar; min tokens" |
| Anthropic | **Progressive disclosure** | SKILL.md corto + references/ para detalles |
| Equipos Reales | Variable | Depende del contexto |
| **Nuevo Propuesto** | **Híbrido** | Telegráfico en SKILL.md + referencias detalladas |

**Pregunta para decidir:** ¿Qué nivel de detalle prefieres en las instrucciones?

```
Opción A: Detallado (tu sistema actual)
  Todo en SKILL.md, sin referencias externas
  Pros: Todo en un lugar
  Contras: Archivos largos, más tokens consumidos

Opción B: Telegráfico (Steipete)
  AGENTS.MD mínimo, confiar en capacidad del modelo
  Pros: Menos tokens, más flexible
  Contras: Menos consistencia, requiere experiencia

Opción C: Progressive disclosure (RECOMENDADO)
  SKILL.md conciso (~150 LOC) + references/ para detalles
  Pros: Balance, carga on-demand
  Contras: Más archivos que mantener
```

**Tu decisión:** _______________

---

#### DECISIÓN 5: ¿YAML Frontmatter obligatorio?

| Visión | Posición | Argumento |
|--------|----------|-----------|
| Tu Sistema | Parcial (algunos tienen) | No estándar |
| Steipete | No usa | Minimalismo |
| Anthropic | **Obligatorio** | name + description requeridos para activación |
| Equipos Reales | N/A | No aplica |
| **Nuevo Propuesto** | **Obligatorio** | Alineado con estándar Anthropic |

**Formato Anthropic:**
```yaml
---
name: developer
description: "Full description of what this skill does and when to use it"
triggers:
  - implement
  - fix
  - code
---
```

**Pregunta para decidir:** ¿Adoptar el estándar Anthropic de frontmatter?

```
Opción A: No usar frontmatter
  Activación manual por keywords en AGENTS.MD

Opción B: Frontmatter obligatorio (RECOMENDADO)
  Todos los SKILL.md tienen name + description + triggers
  Permite activación automática
```

**Tu decisión:** _______________

---

## PARTE 4: Paralelismo y Coordinación

### 4.1 Tabla Comparativa

| Aspecto | Tu Sistema | Steipete | Anthropic | Equipos Reales | Nuevo Propuesto |
|---------|------------|----------|-----------|----------------|-----------------|
| **Tipo de paralelismo** | Daemon + Worktrees | tmux manual (3-8) | Lead + Subagents | Feature branches | Híbrido (3 opciones) |
| **Aislamiento** | Worktrees siempre | Mismo directorio | Contexto separado | Git branches | Condicional |
| **Coordinación** | Beads (automático) | Usuario (manual) | Lead Agent | Scrum + PRs | Lead Agent + Beads |
| **Max paralelo** | 4 (daemon) | 3-8 (manual) | 10+ (subagents) | N devs | 4 (configurable) |

### 4.2 Opciones de Paralelismo del Documento

| Opción | Descripción | Complejidad | Intervención |
|--------|-------------|-------------|--------------|
| **A: Subagentes** | Claude Code lanza subagentes internamente | Baja | Mínima |
| **B-Manual** | Múltiples ventanas Antigravity | Media | Alta |
| **B-Auto** | Daemon + Proxy + Worktrees | Alta | Mínima (post-setup) |

### 4.3 Análisis de Decisiones de Paralelismo

#### DECISIÓN 6: ¿Modo de paralelismo principal?

| Visión | Preferencia | Argumento |
|--------|-------------|-----------|
| Tu Sistema | B-Auto (Daemon) | Automatización completa |
| Steipete | **B-Manual (tmux)** | Control directo, sin overhead |
| Anthropic | **A (Subagentes)** | Integrado en el modelo |
| Equipos Reales | Similar a B-Auto | CI/CD automatizado |
| **Nuevo Propuesto** | **Híbrido según complejidad** | A para simple, B-Auto para sprints |

**Pregunta para decidir:** ¿Cuál es tu modo preferido de trabajo?

```
Opción A: Subagentes siempre (más simple)
  Claude maneja todo internamente
  Tú esperas resultado
  Ideal para: Análisis, auditorías, tareas únicas

Opción B: Manual (múltiples ventanas)
  Tú abres ventanas, das instrucciones
  Control total pero más trabajo
  Ideal para: Cuando quieres supervisar cada agente

Opción C: Automático (Daemon)
  Lead Agent crea tareas en Beads
  Daemon ejecuta en paralelo
  Ideal para: Sprints, "déjalo trabajando"

Opción D: Híbrido según complejidad (RECOMENDADO)
  Simple → A (subagentes)
  Media → B-Manual o A
  Compleja → C (Daemon)
```

**Tu decisión:** _______________

---

#### DECISIÓN 7: ¿Worktrees siempre o condicionales?

| Visión | Posición | Argumento |
|--------|----------|-----------|
| Tu Sistema | **Siempre** | Evita conflictos 100% |
| Steipete | **Nunca** | "Work tree approaches slow me down" |
| Anthropic | N/A (contexto virtual) | No usa worktrees físicos |
| Equipos Reales | Feature branches | Similar concepto |
| **Nuevo Propuesto** | **Condicional** | Solo si hay riesgo de conflicto |

**Pregunta para decidir:** ¿Cuándo usar worktrees?

```
Opción A: Siempre (tu sistema actual)
  Cada agente paralelo → su propio worktree
  Pros: Cero conflictos garantizado
  Contras: Overhead de crear/merge/eliminar

Opción B: Nunca (Steipete)
  Todos en mismo directorio
  Pros: Simple, rápido
  Contras: Posibles conflictos si tocan mismos archivos

Opción C: Condicional (RECOMENDADO)
  Lead Agent analiza archivos de cada tarea
  Si solapan → Worktrees
  Si no solapan → Mismo directorio
```

**Tu decisión:** _______________

---

#### DECISIÓN 8: ¿Cuántos workers paralelos máximo?

| Visión | Número | Contexto |
|--------|--------|----------|
| Tu Sistema (Daemon) | 4 | Configuración actual |
| Steipete | 3-8 | Depende de tarea |
| Anthropic | 1-10+ | Según complejidad |
| **Nuevo Propuesto** | **2-4 inicial, escalar si OK** | Conservador |

**Consideraciones:**
- Tu suscripción Max puede tener rate limits
- Más workers = más tokens simultáneos
- Empezar conservador, subir si no hay throttling

```
Opción A: 2 workers (muy conservador)
Opción B: 4 workers (RECOMENDADO)
Opción C: 6+ workers (agresivo, riesgo de throttling)
```

**Tu decisión:** _______________

---

## PARTE 5: Herramientas y Configuración

### 5.1 Tabla Comparativa

| Herramienta | Tu Sistema | Steipete | Anthropic | Nuevo Propuesto |
|-------------|------------|----------|-----------|-----------------|
| **Task tracking** | Beads | No usa | No especifica | Beads (opcional) |
| **Proxy** | antigravity-claude-proxy | No usa | No aplica | Mantener |
| **Scripts** | No tiene | committer, docs-list, browser-tools | scripts/ en skills | Añadir básicos |
| **MCPs** | No usa | **Rechaza** ("clutters context") | Usa cuando necesario | Selectivo |
| **Modelos** | No diferenciado | Haiku/Opus | Opus/Sonnet | Haiku/Sonnet/Opus |

### 5.2 Análisis de Decisiones de Herramientas

#### DECISIÓN 9: ¿Usar MCPs?

| Visión | Posición | Argumento |
|--------|----------|-----------|
| Steipete | **Rechaza** | "Clutters context" |
| Anthropic | Usa selectivamente | Cuando aporta valor |
| Tu Sistema | No usa actualmente | — |
| **Nuevo Propuesto** | **Selectivo** | Solo los necesarios |

**Pregunta para decidir:** ¿Qué MCPs (si alguno) quieres usar?

```
Opción A: Ninguno (Steipete)
  CLI tools para todo

Opción B: Selectivo (RECOMENDADO)
  Solo MCPs que realmente uses (filesystem, git, etc.)
  Evitar MCPs que dupliquen CLI

Opción C: Todos los disponibles
  Máxima capacidad, más contexto consumido
```

**Tu decisión:** _______________

---

#### DECISIÓN 10: ¿Modelo diferenciado por tarea?

| Visión | Estrategia |
|--------|------------|
| Tu Sistema | Mismo modelo para todo |
| Steipete | **Haiku para velocidad, Opus para review** |
| Anthropic | **Opus (lead) + Sonnet (workers)** |
| **Nuevo Propuesto** | **Diferenciado** |

**Propuesta de asignación:**

| Tipo de Tarea | Modelo | Razón |
|---------------|--------|-------|
| Quick fixes, búsquedas | Haiku | Velocidad, bajo costo |
| Implementación normal | Sonnet | Balance |
| Arquitectura, review complejo | Opus | Máxima calidad |

**Pregunta para decidir:** ¿Usar modelos diferentes según tarea?

```
Opción A: Mismo modelo siempre
  Simplicidad, consistencia

Opción B: Diferenciado (RECOMENDADO)
  Haiku: tareas rápidas
  Sonnet: implementación
  Opus: arquitectura, review
```

**Tu decisión:** _______________

---

#### DECISIÓN 11: ¿Mantener soporte Gemini?

| Contexto | Detalle |
|----------|---------|
| Tu Sistema actual | Daemon tiene GeminiWorker |
| Uso real | Actualmente solo Claude |
| Costo de mantener | Bajo (código ya existe) |
| Costo de eliminar | Medio (refactor) |

```
Opción A: Eliminar (simplificar)
Opción B: Mantener desactivado (RECOMENDADO)
Opción C: Activar y usar (Gemini para planning)
```

**Tu decisión:** _______________

---

## PARTE 6: Flujo de Trabajo

### 6.1 Flujos Comparados

#### Tu Sistema Actual
```
Usuario → tech-lead (plan) → orchestrator (dispatch) → [13 agentes] → merge
```

#### Steipete
```
Usuario ←→ Conversación directa (múltiples tmux si necesario)
```

#### Anthropic
```
Usuario → Lead Agent → [Subagentes paralelos] → Síntesis
```

#### Equipos Reales
```
PO → Planning Meeting → Sprint → [Devs paralelos] → PRs → Review → Merge
```

#### Nuevo Propuesto
```
SIMPLE:
Usuario → Developer (directo)

MEDIA:
Usuario → Lead Agent → Specialists (secuencial o paralelo manual)

COMPLEJA:
Usuario → Product Owner → Lead Agent → Daemon → [Workers paralelos] → Merge
```

### 6.2 Análisis de Decisiones de Flujo

#### DECISIÓN 12: ¿Cuándo interviene Product Owner?

```
Opción A: Siempre primero
  Todo pasa por PO antes de Lead

Opción B: Solo features nuevas (RECOMENDADO)
  Feature nueva → PO → Lead
  Bug/Refactor → Lead directo

Opción C: Nunca (usuario define todo)
  Usuario ya tiene requisitos claros
```

**Tu decisión:** _______________

---

#### DECISIÓN 13: ¿Quién decide si usar paralelismo?

```
Opción A: Usuario siempre decide
  "Ejecuta en paralelo" / "Ejecuta secuencial"

Opción B: Lead Agent decide (RECOMENDADO)
  Analiza tareas, sugiere paralelo si >3 independientes
  Usuario aprueba

Opción C: Automático según reglas
  >3 tareas independientes → paralelo automático
```

**Tu decisión:** _______________

---

## PARTE 7: Resumen de Decisiones ✅ COMPLETADO

| # | Decisión | Tu Decisión | Notas |
|---|----------|-------------|-------|
| 1 | Identificador default | 💬 assistant | No es agente, solo visual |
| 2 | ¿Fusionar Debug+Review en Developer? | ✅ B: Modos | Debug Mode + Review Mode |
| 3 | ¿Fusionar Tech-Lead+Orchestrator? | ✅ B: Fusionar | → lead-agent |
| 4 | ¿Estilo de instrucciones? | ✅ C: Progressive | <500 LOC + references/ |
| 5 | ¿YAML Frontmatter obligatorio? | ✅ B: Sí | name + description |
| 6 | ¿Modo de paralelismo principal? | ✅ D: Híbrido | Subagentes + Manual + Daemon |
| 7 | ¿Max workers paralelos? | Sin límite fijo | Ajuste dinámico |
| 8 | ¿Worktrees siempre o condicionales? | ✅ C: Condicional | Solo si hay conflicto |
| 9 | ¿Usar MCPs? | ✅ B: Selectivo | Con governance |
| 10 | ¿Modelo diferenciado? | ✅ B: Diferenciado | Opus (planning/security), Sonnet (execution) |
| 11 | ¿Product Owner cuándo? | On-demand | Cuando el usuario lo llame |
| 12 | ¿Mantener Gemini? | ✅ B: Desactivado | Mantener código, desactivar config |
| 13 | UI/Accessibility | ✅ D: ui-specialist | Fusión frontend + a11y, agent-architect on-demand |

---

## PARTE 8: Próximos Pasos

### Implementación en 5 Fases

1. **Fase 1:** Actualizar AGENTS.MD con nueva estructura (11 agentes)
2. **Fase 2:** Crear/modificar skills:
   - Modificar: developer/SKILL.md (añadir modos)
   - Crear: lead-agent/SKILL.md (fusión)
   - Crear: ui-specialist/SKILL.md (nuevo)
   - Mover a on-demand: product-owner, agent-architect
3. **Fase 3:** Crear references/:
   - debugging-guide.md (de systematic-debugger)
   - code-review-checklist.md (de code-reviewer)
   - planning-guide.md (de tech-lead + orchestrator)
   - web-design-guide.md (de frontend + Anthropic)
   - accessibility-guide.md (de accessibility-auditor)
4. **Fase 4:** Actualizar frontmatter YAML en todos los SKILL.md
5. **Fase 5:** Archivar agentes eliminados (.agent/archive/)

---

**Estado:** ✅ DECISIONES COMPLETADAS - LISTO PARA IMPLEMENTAR

*Documento de comparación finalizado el 2026-02-05*
