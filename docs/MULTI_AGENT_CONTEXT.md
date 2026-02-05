# Contexto Multi-Agente: Arquitectura y Opciones

**Documento complementario a:** [IMPLEMENTATION_PLAN_COMPLETE.md](./IMPLEMENTATION_PLAN_COMPLETE.md)
**Fecha:** 2026-02-05
**Estado:** ⚠️ HISTÓRICO - Ver COMPARACION_5_VISIONES.md para arquitectura final

---

## 1. Contexto de la Conversación

### 1.1 Objetivo del Usuario

Usar **múltiples agentes en paralelo** dentro del mismo proyecto, aprovechando la **suscripción Max de Claude** (no API de pago).

### 1.2 Restricciones Identificadas

| Restricción | Implicación |
|-------------|-------------|
| Suscripción Max, no API | No podemos usar `ANTHROPIC_API_KEY` directamente |
| Claude Code for VS Code en Antigravity | Ya usa la suscripción automáticamente |
| Puerto 8080 ocupado | Proyectos de desarrollo usan 8080/8000 |
| Conflictos de archivos | Múltiples agentes no pueden editar el mismo archivo |

---

## 2. Tipos de Paralelismo Disponibles

### 2.1 Opción A: Subagentes Internos (Ya Funciona)

**Cómo funciona:**
```
Tú: "Audita seguridad, rendimiento y tests"
     ↓
Claude Code (una sesión):
  ├── Subagente 1: busca vulnerabilidades  ─┐
  ├── Subagente 2: analiza rendimiento      ├── EN PARALELO
  └── Subagente 3: revisa cobertura        ─┘
     ↓
Claude: "Resultados consolidados..."
```

**Características:**
- ✅ Ya funciona en Claude Code for VS Code
- ✅ Usa tu suscripción Max automáticamente
- ✅ No requiere configuración adicional
- ❌ Tú esperas a que termine para dar siguiente instrucción
- ❌ Limitado a tareas de búsqueda/análisis (no escritura paralela)

**Cuándo usarlo:** Análisis, auditorías, búsquedas en el código.

---

### 2.2 Opción B-Manual: Múltiples Ventanas

**Cómo funciona:**
```
Ventana 1 (Antigravity): Claude trabaja en "Implementar login"
Ventana 2 (Antigravity): Claude trabaja en "Escribir tests"
Ventana 3 (Antigravity): Claude trabaja en "Documentación"
```

**Características:**
- ✅ Usa tu suscripción Max (cada ventana)
- ✅ Tareas completamente independientes
- ✅ Sin configuración adicional
- ❌ Gestión manual (tú abres ventanas, das instrucciones)
- ❌ Sin coordinación automática entre ventanas
- ⚠️ Riesgo de conflictos si tocan mismos archivos

**Cuándo usarlo:** Tareas independientes en diferentes partes del código.

---

### 2.3 Opción B-Automática: Daemon + Proxy + Beads

**Cómo funciona:**
```
Tú: Defines tareas en Beads
     ↓
     bd create "Implementar login" --assignee developer
     bd create "Escribir tests" --assignee test-engineer
     ↓
Daemon (proceso automático):
  ├── Detecta tareas "ready"
  ├── Crea worktrees (aislamiento físico)
  ├── Lanza workers en paralelo ───────────────────┐
  │     ├── Worker 1 → developer → worktree-1     │
  │     ├── Worker 2 → test-engineer → worktree-2 │ PARALELO
  │     └── Worker 3 → docs-writer → worktree-3   │
  └── Merge al finalizar ─────────────────────────┘
     ↓
Tú: Revisas resultado final
```

**Características:**
- ✅ Automatización completa
- ✅ Aislamiento con worktrees (sin conflictos)
- ✅ Coordinación via Beads
- ⚠️ Requiere antigravity-claude-proxy (para usar suscripción)
- ⚠️ Requiere configuración inicial
- ⚠️ El daemon necesita actualizarse para nueva arquitectura

**Cuándo usarlo:** Sprints con múltiples tareas, "déjalo trabajando mientras hago otra cosa".

---

## 3. Infraestructura Actual

### 3.1 Componentes Instalados

| Componente | Estado | Función |
|------------|--------|---------|
| Claude Code for VS Code | ✅ Funcionando | Interfaz principal |
| Antigravity (IDE) | ✅ Funcionando | Wrapper que usa tu suscripción |
| Beads (`bd`) | ✅ Instalado | Task tracker Git-backed |
| antigravity-claude-proxy | ✅ Instalado | Convierte suscripción en API local |
| Daemon | ✅ Existe | Orquestador automático (NO está corriendo) |

### 3.2 Qué Usa Tu Suscripción Max

| Escenario | ¿Usa suscripción? | ¿Cómo? |
|-----------|-------------------|--------|
| Claude Code en Antigravity | ✅ Sí | Automático (Antigravity lo gestiona) |
| Múltiples ventanas Antigravity | ✅ Sí | Cada ventana usa la suscripción |
| Daemon sin proxy | ❌ No | Intentaría usar API (fallaría sin key) |
| Daemon + antigravity-claude-proxy | ✅ Sí | Proxy redirige a tu suscripción |

---

## 4. Flujo Propuesto con Nueva Arquitectura

### 4.1 El Flujo Jerárquico (del Plan de Implementación)

```
Tú: "Quiero añadir autenticación OAuth"
         ↓
    [Product Owner]  ← Define QUÉ (requirements, user stories, MVP)
         ↓
    [Lead Agent]     ← Planifica CÓMO (sprint, waves, asigna agentes)
         ↓
    ┌────┴────┬──────────────┬────────────┐
    ↓         ↓              ↓            ↓
[Developer] [Security] [Test-Eng] [Docs-Writer]
    └────┬────┴──────────────┴────────────┘
         ↓
    [Lead Agent]     ← Valida, merge, reporta
         ↓
       Tú: Revisas resultado
```

### 4.2 Cómo Se Ejecutaría en la Práctica

#### Escenario 1: Sesión Única (Opción A + secuencial)

```
Tú: "Quiero añadir login OAuth"
     ↓
[Product Owner]: Te pregunta requisitos, define MVP
     ↓
[Lead Agent]: Crea sprint con 4 tareas
     ↓
[Developer]: Implementa (tú esperas)
     ↓
[Security]: Revisa (tú esperas)
     ↓
[Test-Engineer]: Tests (tú esperas)
     ↓
[Lead Agent]: Valida todo
     ↓
DONE
```

**Tiempo:** Secuencial (suma de todos los tiempos)
**Intervención tuya:** Mínima después del kick-off

---

#### Escenario 2: Múltiples Ventanas (Opción B-Manual)

```
Tú: "Quiero añadir login OAuth"
     ↓
[Product Owner]: Define requisitos (Ventana 1)
     ↓
[Lead Agent]: Crea sprint, te dice:
  - "Developer: implementar auth en src/auth/"
  - "Test-Engineer: tests en tests/auth/"
  - "Docs-Writer: actualizar README"
     ↓
Tú abres 3 ventanas:
  Ventana 1: "Developer, implementa auth según este spec..."
  Ventana 2: "Test-Engineer, escribe tests para auth..."
  Ventana 3: "Docs-Writer, documenta el nuevo login..."
     ↓
Las 3 trabajan EN PARALELO
     ↓
Tú: Revisas cada una, haces merge manual
```

**Tiempo:** Paralelo (el más largo de los 3)
**Intervención tuya:** Alta (abrir ventanas, dar instrucciones, merge)

---

#### Escenario 3: Daemon Automático (Opción B-Automática)

```
Tú: "Quiero añadir login OAuth"
     ↓
[Product Owner]: Define requisitos
     ↓
[Lead Agent]: Crea tareas en Beads:
  bd create "Implementar auth" --assignee developer
  bd create "Tests auth" --assignee test-engineer
  bd create "Docs auth" --assignee docs-writer
     ↓
Tú: Inicias el daemon (una vez)
  cd daemon && npm start
     ↓
Daemon (automático):
  - Crea worktree para cada tarea
  - Ejecuta 3 workers EN PARALELO
  - Cada worker usa tu suscripción (via proxy)
  - Hace merge automático
     ↓
Tú: Revisas resultado final
```

**Tiempo:** Paralelo (el más largo)
**Intervención tuya:** Mínima (solo iniciar daemon una vez)

---

## 5. Configuración Necesaria para Opción B-Automática

### 5.1 El Proxy (antigravity-claude-proxy)

```bash
# Iniciar en puerto diferente a 8080 (proyectos lo usan)
cd ~/repos/antigravity-claude-proxy
PORT=9090 npm start

# Verificar
curl http://localhost:9090/health
```

### 5.2 El Daemon (cambios necesarios)

El daemon actual está configurado para la arquitectura de 13 agentes. Necesita:

**Cambio 1:** Soportar el proxy como backend

```javascript
// En workers/claude-worker.js, línea 31
// Antes:
this.client = new this.Anthropic.default({ apiKey });

// Después:
this.client = new this.Anthropic.default({
  apiKey: apiKey || 'subscription-via-proxy',
  baseURL: process.env.ANTHROPIC_BASE_URL || 'https://api.anthropic.com'
});
```

**Cambio 2:** Nueva estructura de agentes (tras implementar el plan)

```javascript
// En orchestrator-daemon.js, DEFAULT_CONFIG.models
models: {
  claude: {
    api_key_env: 'ANTHROPIC_API_KEY',  // o dummy si usas proxy
    base_url_env: 'ANTHROPIC_BASE_URL', // NUEVO: para proxy
    model: 'claude-sonnet-4-20250514',
    agents: [
      // Core
      'product-owner', 'lead-agent', 'developer',
      // Specialists
      'security-hardener', 'performance-optimizer',
      'test-engineer', 'devops-engineer',
      // On-demand
      'project-auditor', 'docs-writer'
    ]
  }
  // Gemini removido (solo Claude por ahora)
}
```

**Cambio 3:** Nueva ruta de skills

```javascript
// Actualizar paths para nueva estructura
paths: {
  skills: '.agent/skills',  // Ahora tiene core/, specialists/, on-demand/
  // ...
}
```

### 5.3 Variables de Entorno

```bash
# Para usar con proxy (suscripción Max)
export ANTHROPIC_BASE_URL=http://localhost:9090
export ANTHROPIC_API_KEY=dummy-key  # El proxy no lo necesita real

# Iniciar daemon
cd /c/www/agentes/daemon && npm start
```

---

## 6. Preguntas Abiertas para Revisión

### 6.1 Sobre el Flujo

1. **¿El Product Owner siempre debe intervenir?**
   - Actualmente: Usuario → PO → Lead → Specialists
   - Alternativa: Usuario puede ir directo a Lead si ya tiene requisitos claros
   - **Propuesta:** Lead Agent detecta si necesita PO o no

2. **¿Quién inicia el daemon?**
   - Actualmente: Manual (`npm start`)
   - Alternativa: Auto-start cuando Lead Agent crea tareas en Beads
   - **Propuesta:** Manual por ahora, auto-start como mejora futura

### 6.2 Sobre el Paralelismo

3. **¿Worktrees siempre, o solo cuando hay riesgo de conflicto?**
   - Actualmente: El plan asume worktrees para paralelismo
   - Alternativa: Si las tareas tocan archivos diferentes, no hace falta
   - **Propuesta:** Lead Agent decide basándose en análisis de conflictos

4. **¿Cuántos workers en paralelo?**
   - Daemon actual: max 4
   - Consideración: Tu suscripción Max tiene límite de rate?
   - **Propuesta:** Empezar con 2, subir si no hay throttling

### 6.3 Sobre la Implementación

5. **¿Implementar daemon changes antes o después del plan de arquitectura?**
   - Opción A: Primero el plan (8 agentes), luego daemon
   - Opción B: Daemon básico primero, luego plan
   - **Propuesta:** Primero el plan (más impacto), daemon después

6. **¿Mantener soporte para Gemini en el código?**
   - Actualmente: Daemon tiene GeminiWorker
   - Tu decisión: Solo Claude por ahora, pero dejar posibilidad
   - **Propuesta:** Mantener código, desactivar en config

---

## 7. Resumen de Decisiones Pendientes

| # | Decisión | Opciones | Tu preferencia |
|---|----------|----------|----------------|
| 1 | Modo de paralelismo principal | A (subagentes) / B-Manual / B-Auto | ¿? |
| 2 | Puerto del proxy | 9090 / otro | ¿? |
| 3 | PO obligatorio o detectado | Siempre / Auto-detect | ¿? |
| 4 | Worktrees siempre o condicional | Siempre / Si hay conflicto | ¿? |
| 5 | Max workers paralelos | 2 / 4 / otro | ¿? |
| 6 | Orden de implementación | Plan primero / Daemon primero | ¿? |
| 7 | Soporte Gemini | Mantener / Eliminar | ¿? |

---

## 8. Próximos Pasos Sugeridos

1. **Revisar este documento** - Responder las preguntas abiertas
2. **Aprobar el plan de implementación** - [IMPLEMENTATION_PLAN_COMPLETE.md](./IMPLEMENTATION_PLAN_COMPLETE.md)
3. **Ejecutar las 5 fases** - Nueva arquitectura de 8 agentes
4. **Actualizar el daemon** - Soportar proxy y nueva estructura
5. **Probar flujo completo** - PO → Lead → Specialists en paralelo

---

**Estado:** ESPERANDO REVISIÓN Y DECISIONES

*Documento generado para consolidar la conversación sobre multi-agente*
