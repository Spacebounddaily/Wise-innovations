#!/bin/bash
# Emitauditlog - Reusable audit logging function
# Emits structured audit entries for CI/CD events

Emitauditlog() {
  local workflow_name="${1:-${GITHUB_WORKFLOW:-unknown}}"
  local run_id="${2:-${GITHUB_RUN_ID:-0}}"
  local run_number="${3:-${GITHUB_RUN_NUMBER:-0}}"
  local status="${4:-unknown}"
  local actor="${5:-${GITHUB_ACTOR:-system}}"
  local repo="${6:-${GITHUB_REPOSITORY:-unknown}}"
  local ref="${7:-${GITHUB_REF:-unknown}}"
  local sha="${8:-${GITHUB_SHA:-unknown}}"
  local event="${9:-${GITHUB_EVENT_NAME:-unknown}}"
  
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  
  # Create audit log entry in structured format
  local audit_entry=$(cat <<EOF
{
  "timestamp": "${timestamp}",
  "workflow": "${workflow_name}",
  "run_id": "${run_id}",
  "run_number": "${run_number}",
  "status": "${status}",
  "actor": "${actor}",
  "repository": "${repo}",
  "ref": "${ref}",
  "sha": "${sha}",
  "event": "${event}"
}
EOF
)
  
  # Write to audit.log
  echo "${audit_entry}" >> audit.log
  
  # Also log to console for visibility
  echo "✅ Audit log entry emitted:"
  echo "${audit_entry}"
}

# Export the function for use in other scripts
export -f Emitauditlog
