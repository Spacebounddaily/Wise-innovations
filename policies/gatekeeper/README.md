# Gatekeeper Policies

This directory contains OPA Gatekeeper v3 policies for the Wise-innovations constellation.

## Policies

### ffs-required-labels.yaml
Enforces that all resources have required governance labels:
- `owner`: The team or individual responsible for the resource
- `cost-center`: The cost center for billing and tracking
- `data-class`: The data classification level (e.g., public, internal, confidential)

### ffs-immutable-fields.yaml
Protects critical fields from mutation after resource creation:
- `metadata.labels.owner`
- `metadata.labels.cost-center`
- `metadata.labels.data-class`
- `metadata.annotations.created-by`
- `spec.serviceAccountName`

## Installation

Prerequisites:
- Kubernetes cluster with Gatekeeper v3 installed
- kubectl configured with cluster admin access

### Install Gatekeeper (if not already installed)

```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/release-3.14/deploy/gatekeeper.yaml
```

### Deploy Policies

```bash
# Apply required labels policy
kubectl apply -f ffs-required-labels.yaml

# Apply immutable fields policy
kubectl apply -f ffs-immutable-fields.yaml
```

### Verify Installation

```bash
# Check constraint templates
kubectl get constrainttemplates

# Check constraints
kubectl get ffsrequiredlabels
kubectl get ffsimmutablefields
```

## Testing

### Test Required Labels Policy

Try creating a resource without required labels (should fail):
```bash
kubectl run test-pod --image=nginx
```

Create a resource with required labels (should succeed):
```bash
kubectl run test-pod --image=nginx \
  --labels=owner=platform-team,cost-center=engineering,data-class=internal
```

### Test Immutable Fields Policy

1. Create a resource with labels:
```bash
kubectl run test-pod --image=nginx \
  --labels=owner=platform-team,cost-center=engineering,data-class=internal
```

2. Try to modify an immutable field (should fail):
```bash
kubectl label pod test-pod owner=another-team --overwrite
```

## Customization

To customize the policies for your environment:

1. **Modify required labels**: Edit the `parameters.labels` array in `ffs-required-labels.yaml`
2. **Modify immutable fields**: Edit the `parameters.fields` array in `ffs-immutable-fields.yaml`
3. **Adjust scope**: Modify the `match.namespaces` section to target specific namespaces

## Audit Mode

To test policies without enforcement, add `enforcementAction: dryrun` to the constraint spec:

```yaml
spec:
  enforcementAction: dryrun
  match:
    # ... rest of the spec
```

## Support

For issues or questions about these policies, please open an issue in the repository.
