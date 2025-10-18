# Wise-innovations Shared Libraries

This directory contains reusable shell functions and libraries for the constellation.

## audit.sh

The `audit.sh` library provides the `Emitauditlog` function for creating structured audit entries.

### Usage

#### In a shell script:

```bash
#!/bin/bash
source lib/audit.sh

# Emit an audit log entry
Emitauditlog \
  "workflow-name" \
  "run-id" \
  "run-number" \
  "success" \
  "actor" \
  "repository" \
  "ref" \
  "sha" \
  "event"
```

#### In GitHub Actions workflow:

Use the composite action instead. It automatically picks up GitHub context:

```yaml
- name: Emit audit log
  uses: ./.github/actions/emitauditlog
  with:
    status: success
```

You can optionally override any parameter:

```yaml
- name: Emit custom audit log
  uses: ./.github/actions/emitauditlog
  with:
    status: ${{ job.status }}
    workflow_name: "Custom Workflow Name"
    actor: "system"
```

### Function Signature

```bash
Emitauditlog(workflow_name, run_id, run_number, status, actor, repo, ref, sha, event)
```

**Parameters:**
- `workflow_name`: Name of the workflow (default: $GITHUB_WORKFLOW)
- `run_id`: Workflow run ID (default: $GITHUB_RUN_ID)
- `run_number`: Workflow run number (default: $GITHUB_RUN_NUMBER)
- `status`: Status of the workflow (success, failure, cancelled)
- `actor`: Actor who triggered the workflow (default: $GITHUB_ACTOR)
- `repo`: Repository name (default: $GITHUB_REPOSITORY)
- `ref`: Git reference (default: $GITHUB_REF)
- `sha`: Commit SHA (default: $GITHUB_SHA)
- `event`: Event that triggered the workflow (default: $GITHUB_EVENT_NAME)

**Output:**
Creates/appends to `audit.log` with JSON-formatted entries.

### Example Output

```json
{
  "timestamp": "2025-10-18T09:35:52Z",
  "workflow": "Constellation Check",
  "run_id": "12345678",
  "run_number": "42",
  "status": "success",
  "actor": "spacebounddaily",
  "repository": "Spacebounddaily/Wise-innovations",
  "ref": "refs/heads/main",
  "sha": "abc123def456",
  "event": "push"
}
```

## Contributing

To add new shared libraries:

1. Create a new `.sh` file in this directory
2. Document the functions and usage in this README
3. Export functions that should be available to callers
4. Follow existing naming conventions and style
