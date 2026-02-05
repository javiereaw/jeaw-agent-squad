#!/usr/bin/env node
/**
 * JEAW Agent Squad - Orchestrator Daemon
 *
 * Automatic orchestration for multi-agent workflows.
 * Monitors Beads for tasks and dispatches workers to execute them.
 *
 * Usage:
 *   node orchestrator-daemon.js [options]
 *
 * Options:
 *   --config <path>    Path to config file (default: ./config.json)
 *   --project <path>   Path to project directory (default: cwd)
 *   --status           Show daemon status and exit
 *   --dry-run          Log actions without executing
 *   --help             Show this help
 */

const fs = require('fs');
const path = require('path');
const { spawn, execSync } = require('child_process');

// Workers
const ClaudeWorker = require('./workers/claude-worker');
const GeminiWorker = require('./workers/gemini-worker');

// ============================================================================
// Configuration
// ============================================================================

const DEFAULT_CONFIG = {
  mode: 'auto',
  polling_interval_ms: 5000,
  max_parallel_workers: 4,
  dry_run: false,
  models: {
    claude: {
      api_key_env: 'ANTHROPIC_API_KEY',
      model: 'claude-sonnet-4-20250514',
      max_tokens: 8192,
      agents: ['developer', 'security-hardener', 'performance-optimizer', 'test-engineer', 'devops-engineer', 'ui-specialist']
    },
    gemini: {
      api_key_env: 'GEMINI_API_KEY',
      model: 'gemini-2.0-flash',
      agents: ['project-auditor', 'lead-agent', 'agent-architect', 'docs-writer', 'product-owner']
    }
  },
  beads: {
    command: 'bd',
    ready_filter: '--status ready --format json',
    close_command: 'bd close'
  },
  paths: {
    skills: '.agent/skills',
    agents_md: '.agent/AGENTS.MD',
    log_file: '.daemon.log'
  }
};

// ============================================================================
// Globals
// ============================================================================

let config = { ...DEFAULT_CONFIG };
let projectPath = process.cwd();
let activeWorkers = new Map();
let taskQueue = [];
let isRunning = false;
let stats = {
  started: new Date(),
  tasks_completed: 0,
  tasks_failed: 0,
  total_workers_spawned: 0
};

// ============================================================================
// Logging
// ============================================================================

function log(level, message, data = null) {
  const timestamp = new Date().toISOString();
  const logLine = `[${timestamp}] [${level.toUpperCase()}] ${message}`;

  console.log(logLine);
  if (data) {
    console.log('  ', JSON.stringify(data, null, 2).split('\n').join('\n  '));
  }

  // Also write to log file
  if (config.paths?.log_file) {
    const logPath = path.join(projectPath, config.paths.log_file);
    fs.appendFileSync(logPath, logLine + (data ? '\n  ' + JSON.stringify(data) : '') + '\n');
  }
}

function logInfo(msg, data) { log('info', msg, data); }
function logWarn(msg, data) { log('warn', msg, data); }
function logError(msg, data) { log('error', msg, data); }
function logDebug(msg, data) { if (process.env.DEBUG) log('debug', msg, data); }

// ============================================================================
// Beads Integration
// ============================================================================

function beadsAvailable() {
  try {
    execSync(`${config.beads.command} --version`, { stdio: 'pipe' });
    return true;
  } catch {
    return false;
  }
}

function beadsInitialized() {
  return fs.existsSync(path.join(projectPath, '.beads'));
}

function getReadyTasks() {
  try {
    const cmd = `${config.beads.command} list ${config.beads.ready_filter}`;
    const output = execSync(cmd, { cwd: projectPath, stdio: 'pipe' }).toString();

    if (!output.trim()) return [];

    const tasks = JSON.parse(output);
    return Array.isArray(tasks) ? tasks : [];
  } catch (err) {
    logDebug('Error getting ready tasks', { error: err.message });
    return [];
  }
}

function updateTaskStatus(taskId, status, message = '') {
  if (config.dry_run) {
    logInfo(`[DRY-RUN] Would update task ${taskId} to ${status}`);
    return true;
  }

  try {
    const cmd = `${config.beads.command} update ${taskId} --status ${status}`;
    execSync(cmd, { cwd: projectPath, stdio: 'pipe' });
    return true;
  } catch (err) {
    logError(`Failed to update task ${taskId}`, { error: err.message });
    return false;
  }
}

function closeTask(taskId, message = '') {
  if (config.dry_run) {
    logInfo(`[DRY-RUN] Would close task ${taskId}`);
    return true;
  }

  try {
    const msgArg = message ? `--message "${message.replace(/"/g, '\\"')}"` : '';
    const cmd = `${config.beads.command} close ${taskId} ${msgArg}`;
    execSync(cmd, { cwd: projectPath, stdio: 'pipe' });
    return true;
  } catch (err) {
    logError(`Failed to close task ${taskId}`, { error: err.message });
    return false;
  }
}

// ============================================================================
// Skill Loading
// ============================================================================

function loadSkill(agentName) {
  const skillPath = path.join(projectPath, config.paths.skills, agentName, 'SKILL.md');

  if (!fs.existsSync(skillPath)) {
    logWarn(`Skill not found: ${agentName}`, { path: skillPath });
    return null;
  }

  return fs.readFileSync(skillPath, 'utf-8');
}

function loadAgentsMd() {
  const agentsMdPath = path.join(projectPath, config.paths.agents_md);

  if (!fs.existsSync(agentsMdPath)) {
    logDebug('AGENTS.MD not found', { path: agentsMdPath });
    return '';
  }

  return fs.readFileSync(agentsMdPath, 'utf-8');
}

function getProjectContext() {
  const context = [];

  // Package.json
  const pkgPath = path.join(projectPath, 'package.json');
  if (fs.existsSync(pkgPath)) {
    context.push('## package.json\n```json\n' + fs.readFileSync(pkgPath, 'utf-8') + '\n```');
  }

  // README
  const readmePath = path.join(projectPath, 'README.md');
  if (fs.existsSync(readmePath)) {
    const readme = fs.readFileSync(readmePath, 'utf-8');
    context.push('## README.md (first 500 chars)\n' + readme.slice(0, 500));
  }

  // Directory structure (top level)
  try {
    const files = fs.readdirSync(projectPath).filter(f => !f.startsWith('.'));
    context.push('## Project files\n' + files.join(', '));
  } catch {}

  return context.join('\n\n');
}

// ============================================================================
// Worker Management
// ============================================================================

function getModelForAgent(agentName) {
  if (config.models.claude.agents.includes(agentName)) {
    return 'claude';
  }
  if (config.models.gemini.agents.includes(agentName)) {
    return 'gemini';
  }
  // Default to claude
  return 'claude';
}

async function spawnWorker(task) {
  const agentName = task.assignee || task.agent || 'developer';
  const model = getModelForAgent(agentName);

  logInfo(`Spawning ${model} worker for task ${task.id}`, { agent: agentName });

  // Mark task as in progress
  updateTaskStatus(task.id, 'in_progress');

  // Load skill
  const skill = loadSkill(agentName);
  if (!skill) {
    logError(`Cannot spawn worker: skill not found`, { agent: agentName });
    return null;
  }

  // Build prompt
  const agentsMd = loadAgentsMd();
  const context = getProjectContext();

  const prompt = `
${skill}

${agentsMd}

---

## Current Task

**Task ID:** ${task.id}
**Title:** ${task.title || task.description}
**Description:** ${task.description || ''}
**Priority:** ${task.priority || 'normal'}
**Labels:** ${(task.labels || []).join(', ')}

## Project Context

${context}

---

## Instructions

Execute this task following the skill instructions above.

1. Analyze what needs to be done
2. Make the necessary changes to the codebase
3. Report what you did in a structured format

When complete, output a summary starting with "TASK COMPLETE:" followed by a brief description of what was done.
If you cannot complete the task, output "TASK BLOCKED:" followed by the reason.
`;

  // Create worker based on model
  const Worker = model === 'claude' ? ClaudeWorker : GeminiWorker;
  const modelConfig = config.models[model];

  const worker = new Worker({
    apiKeyEnv: modelConfig.api_key_env,
    model: modelConfig.model,
    maxTokens: modelConfig.max_tokens || 8192,
    projectPath: projectPath,
    dryRun: config.dry_run
  });

  // Track worker
  activeWorkers.set(task.id, {
    worker,
    task,
    model,
    agent: agentName,
    startTime: new Date()
  });

  stats.total_workers_spawned++;

  // Execute
  try {
    const result = await worker.execute(prompt);

    // Check result
    if (result.success) {
      closeTask(task.id, result.summary || 'Completed by daemon');
      stats.tasks_completed++;
      logInfo(`Task ${task.id} completed`, { agent: agentName, summary: result.summary });
    } else {
      updateTaskStatus(task.id, 'blocked', result.error);
      stats.tasks_failed++;
      logError(`Task ${task.id} failed`, { agent: agentName, error: result.error });
    }

    // Run hook if configured
    if (config.hooks?.on_task_complete) {
      try {
        execSync(config.hooks.on_task_complete, { cwd: projectPath });
      } catch {}
    }

  } catch (err) {
    logError(`Worker error for task ${task.id}`, { error: err.message });
    updateTaskStatus(task.id, 'blocked', err.message);
    stats.tasks_failed++;

    if (config.hooks?.on_task_error) {
      try {
        execSync(config.hooks.on_task_error, { cwd: projectPath });
      } catch {}
    }
  } finally {
    activeWorkers.delete(task.id);
  }
}

// ============================================================================
// Main Loop
// ============================================================================

async function pollAndDispatch() {
  if (!isRunning) return;

  // Check for stop file
  if (fs.existsSync(path.join(projectPath, '.daemon.stop'))) {
    logInfo('Stop file detected, shutting down...');
    shutdown();
    return;
  }

  // Get ready tasks
  const readyTasks = getReadyTasks();

  if (readyTasks.length > 0) {
    logDebug(`Found ${readyTasks.length} ready tasks`);
  }

  // Dispatch workers for ready tasks (up to max parallel)
  for (const task of readyTasks) {
    if (activeWorkers.size >= config.max_parallel_workers) {
      logDebug('Max parallel workers reached, waiting...');
      break;
    }

    if (activeWorkers.has(task.id)) {
      continue; // Already being processed
    }

    // Spawn worker (don't await, let it run in parallel)
    spawnWorker(task);
  }

  // Schedule next poll
  setTimeout(pollAndDispatch, config.polling_interval_ms);
}

// ============================================================================
// Lifecycle
// ============================================================================

function loadConfig(configPath) {
  if (fs.existsSync(configPath)) {
    try {
      const userConfig = JSON.parse(fs.readFileSync(configPath, 'utf-8'));
      config = { ...DEFAULT_CONFIG, ...userConfig };

      // Deep merge models
      if (userConfig.models) {
        config.models = {
          claude: { ...DEFAULT_CONFIG.models.claude, ...userConfig.models.claude },
          gemini: { ...DEFAULT_CONFIG.models.gemini, ...userConfig.models.gemini }
        };
      }

      logInfo('Loaded config', { path: configPath });
    } catch (err) {
      logError('Failed to load config', { error: err.message });
    }
  }
}

function showStatus() {
  console.log('\n=== JEAW Orchestrator Daemon Status ===\n');
  console.log(`Project: ${projectPath}`);
  console.log(`Beads: ${beadsAvailable() ? 'available' : 'NOT FOUND'}`);
  console.log(`Beads initialized: ${beadsInitialized() ? 'yes' : 'no'}`);
  console.log(`\nModel configuration:`);
  console.log(`  Claude agents: ${config.models.claude.agents.join(', ')}`);
  console.log(`  Gemini agents: ${config.models.gemini.agents.join(', ')}`);
  console.log(`\nAPI Keys:`);
  console.log(`  ANTHROPIC_API_KEY: ${process.env.ANTHROPIC_API_KEY ? 'set' : 'NOT SET'}`);
  console.log(`  GEMINI_API_KEY: ${process.env.GEMINI_API_KEY ? 'set' : 'NOT SET'}`);

  if (beadsInitialized()) {
    const ready = getReadyTasks();
    console.log(`\nReady tasks: ${ready.length}`);
    ready.forEach(t => console.log(`  - ${t.id}: ${t.title || t.description}`));
  }

  console.log('');
}

function showHelp() {
  console.log(`
JEAW Agent Squad - Orchestrator Daemon

Usage:
  node orchestrator-daemon.js [options]

Options:
  --config <path>    Path to config file (default: ./config.json)
  --project <path>   Path to project directory (default: current directory)
  --status           Show daemon status and exit
  --dry-run          Log actions without executing
  --help             Show this help

Examples:
  node orchestrator-daemon.js
  node orchestrator-daemon.js --project /path/to/myproject
  node orchestrator-daemon.js --config ./my-config.json --dry-run

To stop the daemon:
  - Press Ctrl+C
  - Create a file named .daemon.stop in the project directory
`);
}

function shutdown() {
  isRunning = false;
  logInfo('Shutting down daemon...', stats);

  // Remove stop file if exists
  const stopFile = path.join(projectPath, '.daemon.stop');
  if (fs.existsSync(stopFile)) {
    fs.unlinkSync(stopFile);
  }

  process.exit(0);
}

async function main() {
  // Parse arguments
  const args = process.argv.slice(2);
  let configPath = path.join(__dirname, 'config.json');

  for (let i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--config':
        configPath = args[++i];
        break;
      case '--project':
        projectPath = path.resolve(args[++i]);
        break;
      case '--status':
        loadConfig(configPath);
        showStatus();
        process.exit(0);
      case '--dry-run':
        config.dry_run = true;
        break;
      case '--help':
        showHelp();
        process.exit(0);
    }
  }

  // Load config
  loadConfig(configPath);

  // Validate
  if (!beadsAvailable()) {
    logError('Beads (bd) command not found. Install with: npm install -g beads-cli');
    process.exit(1);
  }

  if (!beadsInitialized()) {
    logError('Beads not initialized in this project. Run: bd init');
    process.exit(1);
  }

  // Check API keys
  const claudeKey = process.env[config.models.claude.api_key_env];
  const geminiKey = process.env[config.models.gemini.api_key_env];

  if (!claudeKey && !geminiKey) {
    logError('No API keys found. Set ANTHROPIC_API_KEY and/or GEMINI_API_KEY');
    process.exit(1);
  }

  if (!claudeKey) {
    logWarn('ANTHROPIC_API_KEY not set. Claude agents will be unavailable.');
  }
  if (!geminiKey) {
    logWarn('GEMINI_API_KEY not set. Gemini agents will be unavailable.');
  }

  // Start
  console.log(`
╔═══════════════════════════════════════════════════════════╗
║         JEAW Agent Squad - Orchestrator Daemon            ║
╠═══════════════════════════════════════════════════════════╣
║  Project: ${projectPath.slice(0, 45).padEnd(45)} ║
║  Max workers: ${String(config.max_parallel_workers).padEnd(42)} ║
║  Polling: every ${String(config.polling_interval_ms + 'ms').padEnd(39)} ║
║  Dry run: ${String(config.dry_run).padEnd(45)} ║
╚═══════════════════════════════════════════════════════════╝
`);

  logInfo('Daemon started', { project: projectPath, config: configPath });

  isRunning = true;

  // Handle shutdown
  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);

  // Start polling
  pollAndDispatch();
}

main().catch(err => {
  logError('Fatal error', { error: err.message, stack: err.stack });
  process.exit(1);
});
