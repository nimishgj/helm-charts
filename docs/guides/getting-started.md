# Getting Started with Helm Charts

This guide will help you get started with deploying applications using the charts in this repository.

## Prerequisites

Before you begin, ensure you have:

- **Kubernetes cluster** (version >= 1.19.0)
- **Helm 3.x** installed
- **kubectl** configured to access your cluster

## Installation

### 1. Add the Helm Repository

```bash
helm repo add nimishgj https://nimishgj.github.io/helm-charts
helm repo update
```

### 2. Install Your First Chart

Deploy a simple Go/Gin application:

```bash
helm install my-app nimishgj/hello-helm
```

### 3. Verify the Deployment

```bash
# Check pods
kubectl get pods -l app.kubernetes.io/name=hello-helm

# Check services
kubectl get services -l app.kubernetes.io/name=hello-helm
```

### 4. Access Your Application

```bash
# Port forward to access locally
kubectl port-forward service/my-app-hello-helm-go-gin 8080:80

# Test the API
curl http://localhost:8080/api/health
```

## Next Steps

- [Explore configuration options](../charts/hello-helm/configuration.md)
- [Try different deployment examples](../../examples/)
- [Learn about production deployments](production-deployment.md)

## Common Commands

```bash
# List available charts
helm search repo nimishgj

# Show chart information
helm show chart nimishgj/hello-helm
helm show values nimishgj/hello-helm

# Upgrade a release
helm upgrade my-app nimishgj/hello-helm --set goGin.replicas=3

# Uninstall
helm uninstall my-app
```