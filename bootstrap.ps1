<#
.SYNOPSIS
    JEAW Agent Squad — Global Bootstrap (run ONCE per machine)
    Installs all infrastructure tools needed for the convergence architecture
.DESCRIPTION
    Installs: Beads, gemini-mcp, antigravity-claude-proxy, Vibe Kanban
    Only needs to run once. Safe to re-run (skips already installed tools).
#>

param(
    [switch]$SkipBeads,
    [switch]$SkipGeminiMcp,
    [switch]$SkipProxy,
    [switch]$SkipKanban,
    [switch]$Status
)

$ErrorActionPreference = "Continue"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host ""
Write-Host "JEAW Agent Squad - Global Bootstrap" -ForegroundColor Cyan
Write-Host ("=" * 50) -ForegroundColor Cyan
Write-Host "Instala infraestructura de convergencia (una sola vez)" -ForegroundColor Gray
Write-Host ""

# ============================================================================
# Status check mode
# ============================================================================

function Test-Tool {
    param([string]$Name, [string]$Command, [string]$Check)
    
    try {
        $result = Invoke-Expression $Check 2>$null
        if ($LASTEXITCODE -eq 0 -or $result) {
            Write-Host "  [OK] $Name" -ForegroundColor Green
            return $true
        }
    }
    catch {}
    Write-Host "  [--] $Name" -ForegroundColor Yellow
    return $false
}

if ($Status) {
    Write-Host "Estado de la infraestructura:" -ForegroundColor White
    Write-Host ""
    Test-Tool "Node.js" "node" "node --version"
    Test-Tool "npm" "npm" "npm --version"
    Test-Tool "Git" "git" "git --version"
    Test-Tool "GitHub CLI" "gh" "gh --version"
    Test-Tool "Claude Code" "claude" "claude --version"
    Test-Tool "Beads (bd)" "bd" "bd --version"
    Test-Tool "Gemini MCP" "gemini-mcp" "npm list -g @rlabs-inc/gemini-mcp"
    
    # Check proxy
    $proxyDir = Join-Path $HOME "repos\antigravity-claude-proxy"
    if (Test-Path $proxyDir) {
        Write-Host "  [OK] antigravity-claude-proxy" -ForegroundColor Green
    }
    else {
        Write-Host "  [--] antigravity-claude-proxy" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Usa sin -Status para instalar lo que falta." -ForegroundColor Gray
    Write-Host ""
    exit 0
}

# ============================================================================
# Prerequisites check
# ============================================================================

Write-Host "Verificando prerequisitos..." -ForegroundColor White

$prereqOk = $true

# Node.js
# Attempt to find Node.js if not in PATH
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    $nodePaths = @(
        "C:\Program Files\nodejs",
        "C:\Program Files (x86)\nodejs"
    )
    foreach ($path in $nodePaths) {
        if (Test-Path $path) {
            Write-Host "  [!] Node.js encontrado en $path pero no en PATH. Agregando temporalmente..." -ForegroundColor Yellow
            $env:Path = "$path;$env:Path"
            break
        }
    }
}

try { node --version 2>$null | Out-Null } catch {
    Write-Host "  [X] Node.js no encontrado. Instala desde https://nodejs.org" -ForegroundColor Red
    $prereqOk = $false
}

# Git
try { git --version 2>$null | Out-Null } catch {
    Write-Host "  [X] Git no encontrado. Instala desde https://git-scm.com" -ForegroundColor Red
    $prereqOk = $false
}

if (-not $prereqOk) {
    Write-Host ""
    Write-Host "Instala los prerequisitos y vuelve a ejecutar." -ForegroundColor Red
    exit 1
}

Write-Host "  [OK] Node.js y Git encontrados" -ForegroundColor Green
Write-Host ""

# ============================================================================
# 1. BEADS
# ============================================================================

if (-not $SkipBeads) {
    Write-Host "[1/4] Beads (task tracker)..." -ForegroundColor Cyan

    $bdExists = $false
    try { bd --version 2>$null | Out-Null; $bdExists = $true } catch {}

    if ($bdExists) {
        Write-Host "  Ya instalado. Saltando." -ForegroundColor Green
    }
    else {
        Write-Host "  Instalando via npm..." -ForegroundColor Blue
        npm install -g beads-cli 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  npm install fallo. Intentando instalacion manual..." -ForegroundColor Yellow
            $beadsDir = Join-Path $HOME "repos\beads"
            if (-not (Test-Path $beadsDir)) {
                git clone https://github.com/steveyegge/beads.git $beadsDir 2>$null
            }
            if (Test-Path $beadsDir) {
                Push-Location $beadsDir
                npm install 2>$null
                npm link 2>$null
                Pop-Location
                Write-Host "  Instalado desde source." -ForegroundColor Green
            }
            else {
                Write-Host "  [!] No se pudo instalar Beads. Puedes instalarlo manualmente despues." -ForegroundColor Yellow
                Write-Host "      https://github.com/steveyegge/beads" -ForegroundColor Gray
            }
        }
        else {
            Write-Host "  Instalado." -ForegroundColor Green
        }
    }
    Write-Host ""
}

# ============================================================================
# 2. GEMINI MCP
# ============================================================================

if (-not $SkipGeminiMcp) {
    Write-Host "[2/4] Gemini MCP (Gemini como oraculo para Claude Code)..." -ForegroundColor Cyan

    # Check if Claude Code is available
    $claudeExists = $false
    try { claude --version 2>$null | Out-Null; $claudeExists = $true } catch {}

    if (-not $claudeExists) {
        Write-Host "  Claude Code no encontrado. Saltando gemini-mcp." -ForegroundColor Yellow
        Write-Host "  Instala Claude Code primero: https://docs.claude.com/en/docs/claude-code" -ForegroundColor Gray
    }
    else {
        # Check for Gemini API key
        $geminiKey = $env:GEMINI_API_KEY
        if ([string]::IsNullOrEmpty($geminiKey)) {
            Write-Host "  GEMINI_API_KEY no encontrada en variables de entorno." -ForegroundColor Yellow
            $geminiKey = Read-Host "  Tu Gemini API Key (Enter para saltar)"
            
            if ([string]::IsNullOrEmpty($geminiKey)) {
                Write-Host "  Saltando. Puedes configurarlo despues con:" -ForegroundColor Yellow
                Write-Host '  claude mcp add gemini -s user -- env GEMINI_API_KEY=TU_KEY npx -y @rlabs-inc/gemini-mcp' -ForegroundColor Gray
            }
            else {
                # Set it permanently
                [Environment]::SetEnvironmentVariable("GEMINI_API_KEY", $geminiKey, "User")
                $env:GEMINI_API_KEY = $geminiKey
            }
        }

        if (-not [string]::IsNullOrEmpty($geminiKey)) {
            Write-Host "  Configurando MCP server en Claude Code..." -ForegroundColor Blue
            claude mcp add gemini -s user -- env "GEMINI_API_KEY=$geminiKey" npx -y "@rlabs-inc/gemini-mcp" 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  Configurado." -ForegroundColor Green
            }
            else {
                Write-Host "  [!] Error al configurar. Puedes hacerlo manualmente:" -ForegroundColor Yellow
                Write-Host '  claude mcp add gemini -s user -- env GEMINI_API_KEY=KEY npx -y @rlabs-inc/gemini-mcp' -ForegroundColor Gray
            }
        }
    }
    Write-Host ""
}

# ============================================================================
# 3. ANTIGRAVITY-CLAUDE-PROXY
# ============================================================================

if (-not $SkipProxy) {
    Write-Host "[3/4] Antigravity Claude Proxy (unifica suscripciones)..." -ForegroundColor Cyan

    $proxyDir = Join-Path $HOME "repos\antigravity-claude-proxy"

    if (Test-Path $proxyDir) {
        Write-Host "  Ya clonado. Actualizando..." -ForegroundColor Blue
        Push-Location $proxyDir
        git pull --quiet 2>$null
        Pop-Location
        Write-Host "  Actualizado." -ForegroundColor Green
    }
    else {
        Write-Host "  Clonando..." -ForegroundColor Blue
        git clone https://github.com/badrisnarayanan/antigravity-claude-proxy.git $proxyDir 2>$null
        if (Test-Path $proxyDir) {
            Push-Location $proxyDir
            npm install 2>$null
            Pop-Location
            Write-Host "  Instalado. Para ejecutar:" -ForegroundColor Green
            Write-Host "    cd $proxyDir && npm start" -ForegroundColor Gray
        }
        else {
            Write-Host "  [!] No se pudo clonar. Puedes hacerlo manualmente:" -ForegroundColor Yellow
            Write-Host "      git clone https://github.com/badrisnarayanan/antigravity-claude-proxy.git $proxyDir" -ForegroundColor Gray
        }
    }
    Write-Host ""
}

# ============================================================================
# 4. VIBE KANBAN
# ============================================================================

if (-not $SkipKanban) {
    Write-Host "[4/4] Vibe Kanban (dashboard visual)..." -ForegroundColor Cyan
    Write-Host "  Vibe Kanban se ejecuta con npx (no necesita instalacion global)." -ForegroundColor Green
    Write-Host "  Para usarlo en un proyecto: npx vibe-kanban" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# Summary
# ============================================================================

Write-Host ("=" * 50) -ForegroundColor Cyan
Write-Host "Bootstrap completado!" -ForegroundColor Green
Write-Host ("=" * 50) -ForegroundColor Cyan
Write-Host ""
Write-Host "Para verificar estado:  .\bootstrap.ps1 -Status" -ForegroundColor Gray
Write-Host ""
Write-Host "Siguiente paso - en cada proyecto nuevo:" -ForegroundColor White
Write-Host '  .\new-project.ps1 -Name mi-proyecto' -ForegroundColor Yellow
Write-Host ""