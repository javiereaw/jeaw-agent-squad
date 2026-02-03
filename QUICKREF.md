# JEAW Agent Squad — Quick Reference

## Primer uso (UNA VEZ en tu máquina)

```powershell
cd C:\www\agentes
.\bootstrap.ps1              # Instala Beads, gemini-mcp, proxy
.\bootstrap.ps1 -Status      # Verifica qué está instalado
```

## Nuevo proyecto (CADA proyecto)

```powershell
cd C:\www\agentes
.\new-project.ps1 -Name "roi-inmobiliario"
.\new-project.ps1 -Name "scorm-aragon"
.\new-project.ps1 -Name "pass-the-ball"
```

Crea `C:\www\<nombre>` con los 11 agentes + Beads. Listo para trabajar.

Si el proyecto está en otra ruta:
```powershell
.\new-project.ps1 -Path "D:\otro-sitio\proyecto"
```

## Actualizar agentes en un proyecto existente

```powershell
cd C:\www\mi-proyecto
powershell -ExecutionPolicy Bypass -File C:\www\agentes\install-agents.ps1
# Elige opción 4
```

## Evolucionar el sistema

```powershell
cd C:\www\agentes
# Edita install-agents.sh / install-agents.ps1
# Bump VERSION
git add -A
git commit -m "feat: descripción del cambio"
git push
```

## Comandos útiles dentro de un proyecto

```
"Audita este proyecto"              → Auditoría completa
"Crea un sprint plan"               → Planificación con Beads
"Ejecuta el Sprint 1"               → Ejecución secuencial
"Ejecuta el Sprint 1 en paralelo"   → Worktrees + waves
"Evalúa el equipo"                  → Retrospectiva de agentes
"Recomienda skills para este proyecto" → Cherry-pick de repos externos
```

## Estado rápido de infraestructura

```powershell
.\bootstrap.ps1 -Status
```

## Estructura de un proyecto configurado

```
mi-proyecto/
├── .agent/skills/    ← 11 agentes (source of truth)
├── .agent/rules/     ← 4 reglas de comportamiento
├── .claude/skills/   ← symlink → .agent/skills/
├── .beads/           ← Task tracker (si está activo)
└── tu código...
```
