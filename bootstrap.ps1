<#
.SYNOPSIS
    JEAW Agent Squad — Global Bootstrap (run ONCE per machine)
    Installs all infrastructure tools needed for the convergence architecture
.DESCRIPTION
    Installs: Beads, gemini-mcp, antigravity-claude-proxy, Vibe Kanban, Orchestrator Daemon
    Only needs to run once. Safe to re-run (skips already installed tools).
#>

param(
    [switch]$SkipBeads,
    [switch]$SkipGeminiMcp,
    [switch]$SkipProxy,
    [switch]$SkipKanban,
    [switch]$SkipDaemon,
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
    Write-Host "  REQUERIDOS:" -ForegroundColor White
    $null = Test-Tool "Node.js" "node" "node --version"
    $null = Test-Tool "npm" "npm" "npm --version"
    $null = Test-Tool "Git" "git" "git --version"
    $null = Test-Tool "Beads (bd)" "bd" "bd --version"

    Write-Host ""
    Write-Host "  OPCIONALES:" -ForegroundColor White
    $null = Test-Tool "GitHub CLI" "gh" "gh --version"
    $null = Test-Tool "Claude Code CLI" "claude" "claude --version"
    $null = Test-Tool "Gemini MCP" "gemini-mcp" "npm list -g @rlabs-inc/gemini-mcp"

    # Check proxy
    $proxyDir = Join-Path $HOME "repos\antigravity-claude-proxy"
    if (Test-Path $proxyDir) {
        Write-Host "  [OK] antigravity-claude-proxy" -ForegroundColor Green
    }
    else {
        Write-Host "  [--] antigravity-claude-proxy" -ForegroundColor Yellow
    }

    # Check daemon
    $daemonDir = Join-Path $PSScriptRoot "daemon"
    $daemonPkg = Join-Path $daemonDir "node_modules"
    if (Test-Path $daemonPkg) {
        Write-Host "  [OK] orchestrator-daemon" -ForegroundColor Green
    }
    else {
        Write-Host "  [--] orchestrator-daemon (run bootstrap to install)" -ForegroundColor Yellow
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
    # Check if NVM for Windows is installed but no version is active
    $nvmExists = Get-Command nvm -ErrorAction SilentlyContinue
    if ($nvmExists) {
        $nvmList = nvm list 2>&1
        if ($nvmList -match "No installations recognized") {
            Write-Host "  [!] NVM instalado pero sin version activa de Node.js." -ForegroundColor Yellow
            Write-Host "      Ejecuta: nvm install lts && nvm use lts" -ForegroundColor Cyan
            $prereqOk = $false
        }
        elseif ($nvmList -match "\*") {
            # NVM has a version but it's not in current shell
            Write-Host "  [!] NVM tiene versiones pero ninguna activa en esta sesion." -ForegroundColor Yellow
            Write-Host "      Ejecuta: nvm use <version>" -ForegroundColor Cyan
            $prereqOk = $false
        }
    }
    else {
        # No NVM, try direct Node.js paths
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
}

try { node --version 2>$null | Out-Null } catch {
    if ($prereqOk) {
        # Only show this if we haven't already given NVM-specific instructions
        Write-Host "  [X] Node.js no encontrado. Instala desde https://nodejs.org" -ForegroundColor Red
        $prereqOk = $false
    }
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
    Write-Host "[1/5] Beads (task tracker)..." -ForegroundColor Cyan

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
            $beadsNpmDir = Join-Path $beadsDir "npm-package"

            if (-not (Test-Path $beadsDir)) {
                Write-Host "  Clonando repositorio..." -ForegroundColor Blue
                git clone https://github.com/steveyegge/beads.git $beadsDir 2>$null
            }

            if (Test-Path $beadsNpmDir) {
                Push-Location $beadsNpmDir
                Write-Host "  Instalando dependencias..." -ForegroundColor Blue
                npm install 2>$null

                # If postinstall failed to extract, try manually
                $bdExe = Join-Path $beadsNpmDir "bin\bd.exe"
                $bdZip = Get-ChildItem (Join-Path $beadsNpmDir "bin") -Filter "*.zip" -ErrorAction SilentlyContinue | Select-Object -First 1
                if (-not (Test-Path $bdExe) -and $bdZip) {
                    Write-Host "  Extrayendo binario manualmente..." -ForegroundColor Blue
                    Expand-Archive -Path $bdZip.FullName -DestinationPath (Join-Path $beadsNpmDir "bin") -Force 2>$null
                }

                npm link 2>$null
                Pop-Location

                # Verify installation
                $bdInstalled = $false
                try { bd --version 2>$null | Out-Null; $bdInstalled = $true } catch {}

                if ($bdInstalled) {
                    Write-Host "  Instalado desde source." -ForegroundColor Green
                }
                else {
                    Write-Host "  [!] Instalacion incompleta. Ejecuta manualmente:" -ForegroundColor Yellow
                    Write-Host "      cd $beadsNpmDir && npm link" -ForegroundColor Gray
                }
            }
            else {
                Write-Host "  [!] No se pudo clonar Beads. Puedes instalarlo manualmente:" -ForegroundColor Yellow
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
    Write-Host "[2/5] Gemini MCP (Gemini como oraculo para Claude Code)..." -ForegroundColor Cyan

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
    Write-Host "[3/5] Antigravity Claude Proxy (unifica suscripciones)..." -ForegroundColor Cyan

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
    Write-Host "[4/5] Vibe Kanban (dashboard visual)..." -ForegroundColor Cyan
    Write-Host "  Vibe Kanban se ejecuta con npx (no necesita instalacion global)." -ForegroundColor Green
    Write-Host "  Para usarlo en un proyecto: npx vibe-kanban" -ForegroundColor Gray
    Write-Host ""
}

# ============================================================================
# 5. ORCHESTRATOR DAEMON
# ============================================================================

if (-not $SkipDaemon) {
    Write-Host "[5/5] Orchestrator Daemon (orquestacion automatica)..." -ForegroundColor Cyan

    $daemonDir = Join-Path $PSScriptRoot "daemon"
    $daemonPkg = Join-Path $daemonDir "node_modules"

    if (Test-Path $daemonPkg) {
        Write-Host "  Ya instalado." -ForegroundColor Green
    }
    else {
        if (Test-Path $daemonDir) {
            Write-Host "  Instalando dependencias del daemon..." -ForegroundColor Blue
            Push-Location $daemonDir
            npm install 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  Instalado." -ForegroundColor Green
                Write-Host "  Para modo automatico en un proyecto:" -ForegroundColor Gray
                Write-Host "    node $daemonDir\orchestrator-daemon.js --project C:\www\mi-proyecto" -ForegroundColor Gray
            }
            else {
                Write-Host "  [!] Error instalando dependencias. Ejecuta manualmente:" -ForegroundColor Yellow
                Write-Host "      cd $daemonDir && npm install" -ForegroundColor Gray
            }
            Pop-Location
        }
        else {
            Write-Host "  [!] Directorio daemon no encontrado." -ForegroundColor Yellow
        }
    }
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