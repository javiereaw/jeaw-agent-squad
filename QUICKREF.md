# JEAW Agent Squad — Quick Reference

## Primera vez (UNA VEZ en tu máquina)

```powershell
cd C:\www\agentes
.\bootstrap.ps1                  # Instala Beads, gemini-mcp, proxy
.\bootstrap.ps1 -Status          # Verificar qué hay instalado
```

## Nuevo proyecto

```powershell
cd C:\www\agentes
.\new-project.ps1 -Name "nombre-proyecto"
```

Crea `C:\www\nombre-proyecto` con 11 agentes + Beads. Listo.

Si el proyecto ya existe o está en otra ruta:
```powershell
.\new-project.ps1 -Path "C:\www\proyecto-existente"
.\new-project.ps1 -Path "D:\otro-sitio"
```

## Actualizar agentes en un proyecto

```powershell
cd C:\www\mi-proyecto
powershell -ExecutionPolicy Bypass -File C:\www\agentes\install-agents.ps1
# Elige opción 4
```

## Evolucionar el sistema

```powershell
cd C:\www\agentes
# Edita los scripts (o pide a Antigravity que lo haga)
"2.1.0" | Set-Content VERSION -NoNewline
git add -A && git commit -m "feat: cambio" && git push
```

## Comandos dentro de un proyecto

```
"Audita este proyecto"                    → Auditoría 8 fases
"Crea un sprint plan"                     → Planificación con Beads
"Ejecuta el Sprint 1"                     → Ejecución secuencial
"Ejecuta el Sprint 1 en paralelo"         → Worktrees + waves
"Evalúa el equipo"                        → Retrospectiva de agentes
"Recomienda skills para este proyecto"    → Cherry-pick de repos externos
"Lee .dev-errors.log y arregla errores"   → Auto-fix desde logs
```

## Estructura de cada proyecto

```
.agent/skills/    ← 11 agentes (source of truth)
.agent/rules/     ← 4 reglas de comportamiento
.claude/skills/   ← symlink → .agent/skills/
.beads/           ← Task tracker (si activo)
```

## Quién hace qué (modelo)

```
Gemini → auditor, tech-lead, orchestrator, architect, a11y (visión global)
Claude → developer, security, perf, tester, devops (ejecución precisa)
```
