#!/usr/bin/env bash
# sync-codex.sh - Generate AGENTS.md for Codex CLI in each project
# Codex doesn't support @import, so it needs real content in AGENTS.md
#
# Usage: ./sync-codex.sh [project_name]
#   No args = sync all projects in parent directory
#   With arg = sync only that project

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CORE_FILE="$SCRIPT_DIR/.agent/AGENTS.MD"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

if [[ ! -f "$CORE_FILE" ]]; then
  echo "ERROR: Core file not found: $CORE_FILE"
  exit 1
fi

sync_project() {
  local project_dir="$1"
  local project_name="$(basename "$project_dir")"
  local claude_md="$project_dir/CLAUDE.md"
  local agents_md="$project_dir/AGENTS.md"

  # Skip agentes itself
  if [[ "$project_name" == "agentes" ]]; then
    return
  fi

  # Skip if no CLAUDE.md (not a managed project)
  if [[ ! -f "$claude_md" ]]; then
    return
  fi

  # Skip if CLAUDE.md doesn't import from agentes (not using our system)
  if ! head -1 "$claude_md" | grep -q '@.*agentes'; then
    echo "SKIP: $project_name (CLAUDE.md doesn't import from agentes)"
    return
  fi

  echo "SYNC: $project_name"

  # Start with core content
  cp "$CORE_FILE" "$agents_md"

  # Extract project-specific content (everything after the @import line)
  local overrides
  overrides="$(tail -n +2 "$claude_md")"

  # Append overrides if non-empty
  if [[ -n "$(echo "$overrides" | tr -d '[:space:]')" ]]; then
    echo "" >> "$agents_md"
    echo "$overrides" >> "$agents_md"
  fi

  echo "  -> $agents_md ($(wc -c < "$agents_md" | tr -d ' ') bytes)"
}

if [[ $# -gt 0 ]]; then
  # Sync specific project
  target="$PARENT_DIR/$1"
  if [[ ! -d "$target" ]]; then
    echo "ERROR: Project not found: $target"
    exit 1
  fi
  sync_project "$target"
else
  # Sync all projects
  echo "Syncing AGENTS.md for Codex CLI..."
  echo "Core: $CORE_FILE"
  echo "---"
  for dir in "$PARENT_DIR"/*/; do
    sync_project "$dir"
  done
  echo "---"
  echo "Done."
fi
