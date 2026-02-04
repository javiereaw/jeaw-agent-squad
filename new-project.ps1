<#
.SYNOPSIS
    JEAW Agent Squad — New Project Setup
    One command to set up agents + convergence in any project
.EXAMPLE
    .\new-project.ps1 -Name "roi-inmobiliario"
    .\new-project.ps1 -Name "scorm-aragon"
    .\new-project.ps1 -Path "D:\otro-sitio\proyecto"
    .\new-project.ps1 -Name "mi-proyecto" -SkipBeads
#>

param(
    [string]$Name,
    [string]$Path,
    [string]$Base = "C:\www",
    
    [switch]$SkipBeads,
    [switch]$SkipAgents
)

$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Resolve path: -Name uses Base, -Path is absolute
if ($Name -and -not $Path) {
    $Path = Join-Path $Base $Name
} elseif (-not $Path) {
    Write-Host "Uso: .\new-project.ps1 -Name 'mi-proyecto'" -ForegroundColor Red
    Write-Host "  o: .\new-project.ps1 -Path 'C:\ruta\completa'" -ForegroundColor Red
    exit 1
}

# Resolve path
$Path = [System.IO.Path]::GetFullPath($Path)

Write-Host ""
Write-Host "JEAW Agent Squad - Project Setup" -ForegroundColor Cyan
Write-Host ("=" * 50) -ForegroundColor Cyan
Write-Host "Proyecto: $Path" -ForegroundColor White
Write-Host ""

# ============================================================================
# Verify project directory exists
# ============================================================================

if (-not (Test-Path $Path)) {
    Write-Host "Creando directorio..." -ForegroundColor Blue
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

Push-Location $Path

# ============================================================================
# 1. Install agents
# ============================================================================

if (-not $SkipAgents) {
    Write-Host "[1/3] Instalando agentes..." -ForegroundColor Cyan

    # Find the install script — try multiple locations
    $scriptLocations = @(
        (Join-Path $PSScriptRoot "install-agents.ps1"),                          # Same dir as this script
        (Join-Path $HOME "repos\jeaw-agent-squad\install-agents.ps1"),           # Cloned repo
        "C:\www\agentes\install-agents.ps1"                                       # Known location
    )

    $installScript = $null
    foreach ($loc in $scriptLocations) {
        if (Test-Path $loc) {
            $installScript = $loc
            break
        }
    }

    if ($installScript) {
        Write-Host "  Usando: $installScript" -ForegroundColor Gray
        
        # Run install-agents.ps1 — we need to simulate option 4 (project install)
        # Since install-agents.ps1 is interactive, we pipe the option
        "4" | powershell -ExecutionPolicy Bypass -File $installScript
        
        Write-Host "  Agentes instalados." -ForegroundColor Green
    } else {
        Write-Host "  [!] No se encontro install-agents.ps1" -ForegroundColor Yellow
        Write-Host "  Intentando instalacion remota..." -ForegroundColor Blue
        
        # Download and run
        $tempScript = Join-Path $env:TEMP "install-agents.ps1"
        try {
            Invoke-WebRequest -Uri "https://raw.githubusercontent.com/javiereaw/jeaw-agent-squad/main/install-agents.ps1" -OutFile $tempScript
            "4" | powershell -ExecutionPolicy Bypass -File $tempScript
            Remove-Item $tempScript -Force
            Write-Host "  Agentes instalados." -ForegroundColor Green
        } catch {
            Write-Host "  [!] Error descargando. Verifica tu conexion." -ForegroundColor Red
        }
    }
    Write-Host ""
}

# ============================================================================
# 2. Initialize Git (if needed)
# ============================================================================

Write-Host "[2/3] Verificando Git..." -ForegroundColor Cyan

if (-not (Test-Path ".git")) {
    Write-Host "  Inicializando repositorio Git..." -ForegroundColor Blue
    git init 2>$null
    git branch -m main 2>$null
    Write-Host "  Git inicializado." -ForegroundColor Green
} else {
    Write-Host "  Git ya inicializado." -ForegroundColor Green
}

# Add .agent and .beads to .gitignore if not present
$gitignorePath = Join-Path $Path ".gitignore"
$entriesToAdd = @()

if (Test-Path $gitignorePath) {
    $content = Get-Content $gitignorePath -Raw
} else {
    $content = ""
}

# .beads should be tracked (it's part of the project state)
# .trees should NOT be tracked (temporary worktrees)
if ($content -notmatch '\.trees/') {
    $entriesToAdd += ".trees/"
}

if ($entriesToAdd.Count -gt 0) {
    $addition = "`n# JEAW Agent Squad`n" + ($entriesToAdd -join "`n") + "`n"
    Add-Content $gitignorePath $addition
    Write-Host "  .gitignore actualizado." -ForegroundColor Green
}

Write-Host ""

# ============================================================================
# 3. Initialize Beads
# ============================================================================

if (-not $SkipBeads) {
    Write-Host "[3/3] Inicializando Beads..." -ForegroundColor Cyan

    if (Test-Path ".beads") {
        Write-Host "  Beads ya inicializado." -ForegroundColor Green
    } else {
        $bdExists = $false
        try { bd --version 2>$null | Out-Null; $bdExists = $true } catch {}

        if ($bdExists) {
            bd init 2>$null
            if (Test-Path ".beads") {
                Write-Host "  Beads inicializado." -ForegroundColor Green
            } else {
                Write-Host "  [!] bd init fallo." -ForegroundColor Yellow
            }
        } else {
            Write-Host "  [!] Beads (bd) no instalado. Ejecuta bootstrap.ps1 primero." -ForegroundColor Yellow
            Write-Host "      O instala manualmente: npm install -g beads-cli" -ForegroundColor Gray
        }
    }
    Write-Host ""
}

# ============================================================================
# Summary
# ============================================================================

Pop-Location

Write-Host ("=" * 50) -ForegroundColor Cyan
Write-Host "Proyecto configurado!" -ForegroundColor Green
Write-Host ("=" * 50) -ForegroundColor Cyan
Write-Host ""
Write-Host "Estructura creada:" -ForegroundColor White
Write-Host "  $Path" -ForegroundColor Gray
Write-Host "    .agent/AGENTS.MD  <- Reglas globales + Iron Laws" -ForegroundColor Gray
Write-Host "    .agent/skills/    <- 13 agentes" -ForegroundColor Gray
Write-Host "    .claude/skills/   <- symlink -> .agent/skills/" -ForegroundColor Gray

$beadsPath = Join-Path $Path ".beads"
if (Test-Path $beadsPath) {
    Write-Host "    .beads/           <- Task tracker inicializado" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Abre el proyecto en Antigravity o Claude Code y di:" -ForegroundColor White
Write-Host '  "Audita este proyecto"' -ForegroundColor Yellow
Write-Host '  "Crea un sprint plan"' -ForegroundColor Yellow
Write-Host '  "Ejecuta el Sprint 1 en paralelo"' -ForegroundColor Yellow
Write-Host ""
Write-Host "Para mas proyectos:" -ForegroundColor Gray
Write-Host '  .\new-project.ps1 -Name "otro-proyecto"' -ForegroundColor Gray
Write-Host ""
