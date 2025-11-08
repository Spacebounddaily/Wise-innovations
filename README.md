# Wise-innovations Constellation

Welcome to the Wise-innovations repository - a constellation of CI/CD workflows, shared libraries, and governance policies designed for enterprise-grade cloud deployments.

## 🌟 Overview

This repository provides:

- **Audit Logging Integration**: Structured audit trail for all CI/CD events
- **Shared Libraries**: Reusable shell functions for consistent operations
- **Gatekeeper Policies**: Kubernetes governance and compliance policies
- **CI/CD Workflows**: Automated deployment and integrity checks

## 📁 Repository Structure

```
.
├── .github/
│   ├── actions/
│   │   └── emitauditlog/        # Composite action for audit logging
│   └── workflows/
│       ├── constellation-check.yml  # Constellation integrity checks
│       └── openshift.yml            # OpenShift deployment workflow
├── lib/
│   ├── audit.sh                 # Reusable audit logging functions
│   └── README.md
├── policies/
│   └── gatekeeper/
│       ├── ffs-required-labels.yaml    # Required labels policy
│       ├── ffs-immutable-fields.yaml   # Immutable fields policy
│       └── README.md
└── README.md
```

## 🚀 Quick Start

### Using Audit Logging

The audit logging system creates structured JSON logs for all CI/CD events:

```yaml
- name: Emit audit log
  uses: ./.github/actions/emitauditlog
  with:
    status: success
```

Audit logs are automatically uploaded as artifacts and retained for 90 days.

### Applying Gatekeeper Policies

Prerequisites:
- Kubernetes cluster with Gatekeeper v3 installed
- kubectl configured with admin access

```bash
# Apply policies
kubectl apply -f policies/gatekeeper/ffs-required-labels.yaml
kubectl apply -f policies/gatekeeper/ffs-immutable-fields.yaml
```

See [policies/gatekeeper/README.md](policies/gatekeeper/README.md) for detailed instructions.

## 🔧 Components

### Constellation Check Workflow

The `constellation-check.yml` workflow performs:
- Repository integrity verification
- Structured audit log emission
- Artifact upload for compliance tracking

Triggered on:
- Push to main/master branches
- Pull requests
- Manual workflow dispatch

### Audit Logging System

#### Components:
- **lib/audit.sh**: Core audit logging function
- **.github/actions/emitauditlog**: Reusable composite action

#### Features:
- Structured JSON audit entries
- Automatic GitHub context population
- 90-day artifact retention
- Console visibility for debugging

#### Audit Entry Format:
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

### Gatekeeper Policies

#### ffs-required-labels
Enforces required governance labels on all resources:
- `owner`: Resource owner
- `cost-center`: Billing allocation
- `data-class`: Data classification level

#### ffs-immutable-fields
Protects critical fields from modification after creation:
- Label fields (owner, cost-center, data-class)
- Annotation fields (created-by)
- Security fields (serviceAccountName)

## 🛠️ Development

### Adding New Workflows

1. Create workflow file in `.github/workflows/`
2. Add audit logging step:
   ```yaml
   - uses: ./.github/actions/emitauditlog
     with:
       status: ${{ job.status }}
   ```
3. Upload audit.log as artifact

### Creating Shared Libraries

1. Add new `.sh` file to `lib/`
2. Export reusable functions
3. Document in `lib/README.md`
4. Source in workflows or actions

### Adding Gatekeeper Policies

1. Create ConstraintTemplate and Constraint in `policies/gatekeeper/`
2. Test in dry-run mode first
3. Document in `policies/gatekeeper/README.md`
4. Apply to cluster

## 📊 Monitoring and Compliance

### Viewing Audit Logs

1. Navigate to Actions tab in GitHub
2. Select workflow run
3. Download audit-log artifact
4. Extract and review JSON entries

### Verifying Policy Compliance

```bash
# List all constraint violations
kubectl get events --field-selector reason=FailedValidation

# Check specific constraint status
kubectl describe ffsrequiredlabels require-governance-labels
kubectl describe ffsimmutablefields protect-critical-fields
```

## 🤝 Contributing

When contributing to this repository:

1. Follow existing code style and conventions
2. Add audit logging to new workflows
3. Test changes in feature branches
4. Update documentation as needed
5. Ensure YAML files pass linting (yamllint)
6. Validate shell scripts (bash -n)

## 📚 Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [OPA Gatekeeper Documentation](https://open-policy-agent.github.io/gatekeeper/)
- [Composite Actions Guide](https://docs.github.com/en/actions/creating-actions/creating-a-composite-action)

## 🔐 Security

- Audit logs may contain sensitive information - review before sharing
- Gatekeeper policies enforce least-privilege access
- All workflows use pinned action versions for security
- Secrets are managed via GitHub repository secrets

## 📄 License

See repository license file for details.

## 📞 Support

For questions or issues:
- Open an issue in this repository
- Review existing documentation in subdirectories
- Check workflow run logs for troubleshooting

---

**Constellation Status**: ✅ Aligned and operational

Last updated: 2025-10-18
