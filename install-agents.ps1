<#
.SYNOPSIS
    JEAW Agent Squad - Installer
    Instala el equipo de 13 agentes especializados desde GitHub
.DESCRIPTION
    Descarga la última versión del repositorio y configura los agentes.
    Compatible con: Claude Code, Antigravity, Gemini CLI, Cursor, Codex
#>

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$RepoUrl = "https://github.com/javiereaw/jeaw-agent-squad.git"
$TempDir = Join-Path $env:TEMP "jeaw-agent-squad-$(Get-Random)"

Write-Host ""
Write-Host "JEAW Agent Squad - Installer" -ForegroundColor Cyan
Write-Host ("=" * 45) -ForegroundColor Cyan
Write-Host ""
Write-Host "Donde quieres instalar los agentes?" -ForegroundColor White
Write-Host ""
Write-Host "  1) " -NoNewline -ForegroundColor Green; Write-Host "Global Antigravity   -> ~/.gemini/antigravity/"
Write-Host "  2) " -NoNewline -ForegroundColor Green; Write-Host "Global Claude Code   -> ~/.claude/"
Write-Host "  3) " -NoNewline -ForegroundColor Green; Write-Host "Global ambos         -> Antigravity + symlink Claude Code"
Write-Host "  4) " -NoNewline -ForegroundColor Green; Write-Host "Proyecto actual      -> .agent/ + symlink .claude/"
Write-Host "  5) " -NoNewline -ForegroundColor Green; Write-Host "Ruta personalizada"
Write-Host ""
$option = Read-Host "Opcion [1-5]"

$canonical = ""
$symlinks = @()

switch ($option) {
    "1" {
        $canonical = Join-Path $HOME ".gemini\antigravity"
    }
    "2" {
        $canonical = Join-Path $HOME ".claude"
    }
    "3" {
        $canonical = Join-Path $HOME ".gemini\antigravity"
        $symlinks = @(Join-Path $HOME ".claude")
    }
    "4" {
        $canonical = Join-Path (Get-Location) ".agent"
        $symlinks = @(Join-Path (Get-Location) ".claude")
    }
    "5" {
        $custom = Read-Host "Ruta completa"
        $canonical = $custom
    }
    default {
        Write-Host "Opcion no valida" -ForegroundColor Red
        exit 1
    }
}

# ============================================================================
# Descargar del repositorio
# ============================================================================

Write-Host ""
Write-Host "Descargando desde GitHub..." -ForegroundColor Cyan

try {
    git clone --depth 1 --quiet $RepoUrl $TempDir 2>$null
    Write-Host "  Repositorio clonado" -ForegroundColor Green
} catch {
    Write-Host "Error: No se pudo clonar el repositorio. Verifica tu conexion." -ForegroundColor Red
    exit 1
}

# ============================================================================
# Copiar archivos
# ============================================================================

Write-Host ""
Write-Host "Instalando en: $canonical" -ForegroundColor Cyan

# Crear directorio destino si no existe
if (-not (Test-Path $canonical)) {
    New-Item -ItemType Directory -Path $canonical -Force | Out-Null
}

# Copiar AGENTS.MD
$sourceAgentsMd = Join-Path $TempDir ".agent\AGENTS.MD"
if (Test-Path $sourceAgentsMd) {
    Copy-Item $sourceAgentsMd $canonical -Force
    Write-Host "  AGENTS.MD copiado" -ForegroundColor Green
}

# Copiar skills/
$sourceSkills = Join-Path $TempDir ".agent\skills"
$destSkills = Join-Path $canonical "skills"
if (Test-Path $sourceSkills) {
    if (Test-Path $destSkills) {
        Remove-Item $destSkills -Recurse -Force
    }
    Copy-Item $sourceSkills $destSkills -Recurse
    Write-Host "  skills/ copiado (13 agentes)" -ForegroundColor Green
}

# ============================================================================
# Crear symlinks
# ============================================================================

if ($symlinks.Count -gt 0) {
    Write-Host ""
    Write-Host "Creando symlinks..." -ForegroundColor Cyan

    foreach ($symlinkPath in $symlinks) {
        # Crear directorio padre si no existe
        if (-not (Test-Path $symlinkPath)) {
            New-Item -ItemType Directory -Path $symlinkPath -Force | Out-Null
        }

        # Symlink para skills/
        $symlinkSkills = Join-Path $symlinkPath "skills"
        $canonicalSkills = Join-Path $canonical "skills"

        if (Test-Path $symlinkSkills) {
            $item = Get-Item $symlinkSkills -Force
            if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
                cmd /c "rmdir `"$symlinkSkills`"" 2>$null
            } else {
                Remove-Item $symlinkSkills -Recurse -Force
            }
        }

        # Usar junction (funciona sin admin en Windows)
        cmd /c "mklink /J `"$symlinkSkills`" `"$canonicalSkills`"" 2>$null | Out-Null
        Write-Host "  $symlinkSkills -> $canonicalSkills" -ForegroundColor Green
    }
}

# ============================================================================
# Clonar repositorios externos de skills
# ============================================================================

$reposDir = Join-Path $HOME "repos\agent-skills-sources"

Write-Host ""
Write-Host "Configurando repositorios de skills externos..." -ForegroundColor Cyan

function Clone-OrUpdateRepo {
    param([string]$RepoUrl, [string]$RepoDir, [string]$RepoName)
    if (Test-Path (Join-Path $RepoDir ".git")) {
        Write-Host "  Actualizando $RepoName..." -ForegroundColor Blue
        Push-Location $RepoDir
        git pull --quiet 2>$null
        Pop-Location
        Write-Host "  $RepoName actualizado" -ForegroundColor Green
    } else {
        Write-Host "  Clonando $RepoName..." -ForegroundColor Blue
        try {
            git clone --quiet $RepoUrl $RepoDir 2>$null
            Write-Host "  $RepoName clonado" -ForegroundColor Green
        } catch {
            Write-Host "  No se pudo clonar $RepoName (sin red?)" -ForegroundColor Yellow
        }
    }
}

if (-not (Test-Path $reposDir)) { New-Item -ItemType Directory -Path $reposDir -Force | Out-Null }
Clone-OrUpdateRepo "https://github.com/anthropics/anthropic-cookbook.git" (Join-Path $reposDir "anthropic-cookbook") "Anthropic Cookbook"
Clone-OrUpdateRepo "https://github.com/anthropics/courses.git" (Join-Path $reposDir "anthropic-courses") "Anthropic Courses"

# ============================================================================
# Limpiar
# ============================================================================

Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue

# ============================================================================
# Resumen
# ============================================================================

Write-Host ""
Write-Host ("=" * 45) -ForegroundColor Cyan
Write-Host "Instalacion completada!" -ForegroundColor Green
Write-Host ""
Write-Host "Estructura instalada:" -ForegroundColor White
Write-Host "  $canonical" -ForegroundColor Cyan
Write-Host "    AGENTS.MD        <- Reglas globales + Iron Laws" -ForegroundColor Gray
Write-Host "    skills/          <- 13 agentes especializados" -ForegroundColor Gray

if ($symlinks.Count -gt 0) {
    Write-Host ""
    Write-Host "Symlinks creados:" -ForegroundColor White
    foreach ($s in $symlinks) {
        Write-Host "  $s\skills -> $canonical\skills" -ForegroundColor Cyan
    }
}

Write-Host ""
Write-Host "Agentes disponibles:" -ForegroundColor White
Write-Host "  project-auditor, tech-lead, developer, security-hardener," -ForegroundColor Gray
Write-Host "  performance-optimizer, test-engineer, docs-writer, devops-engineer," -ForegroundColor Gray
Write-Host "  accessibility-auditor, orchestrator, agent-architect," -ForegroundColor Gray
Write-Host "  code-reviewer, systematic-debugger" -ForegroundColor Gray
Write-Host ""
Write-Host "Para actualizar en el futuro, vuelve a ejecutar este script." -ForegroundColor Yellow
Write-Host ""
