# Helm Charts Repository

A collection of production-ready Helm charts for deploying applications on Kubernetes.

## Repository Structure

```
helm-charts/
├── charts/          # Helm charts
│   └── hello-helm/  # Multi-framework REST API chart
├── docs/            # Documentation
│   ├── guides/      # Getting started and deployment guides
│   ├── charts/      # Chart-specific documentation
│   └── api/         # API documentation
├── examples/        # Example configurations
│   └── hello-helm/  # Example deployments and values
└── .github/         # GitHub Actions for automated releases
```

## Available Charts

### hello-helm

A comprehensive Helm chart for deploying multi-framework REST API applications on Kubernetes.

**Supported Frameworks:**
- Go/Gin
- Java/SpringBoot
- Node.js/Express
- Python/FastAPI
- PHP/Laravel

**Key Features:**
- Conditional deployment (enable/disable frameworks individually)
- Production-ready configurations
- Comprehensive health checks and monitoring
- Resource management and security contexts
- Consistent REST API across all frameworks

## Quick Start

### Add the Repository

```bash
helm repo add nimishgj https://nimishgj.github.io/helm-charts
helm repo update
```

### Install Your First Chart

```bash
# Install with default settings (Go/Gin only)
helm install my-app nimishgj/hello-helm

# Install with multiple frameworks
helm install my-app nimishgj/hello-helm \
  --set goGin.enabled=true \
  --set nodejsExpress.enabled=true \
  --set pythonFastapi.enabled=true
```

### Verify Installation

```bash
# Check deployment status
kubectl get pods -l app.kubernetes.io/name=hello-helm

# Access the application
kubectl port-forward service/my-app-hello-helm-go-gin 8080:80
curl http://localhost:8080/api/health
```

## Documentation

- **[Getting Started Guide](docs/guides/getting-started.md)** - Quick start and basic usage
- **[Chart Documentation](charts/hello-helm/README.md)** - Detailed chart documentation
- **[API Reference](docs/api/rest-api.md)** - REST API documentation
- **[Examples](examples/)** - Sample configurations and deployments

## Examples

The `examples/` directory contains ready-to-use configurations:

- **[Basic Deployment](examples/hello-helm/basic/)** - Single framework setup
- **[Multi-Framework](examples/hello-helm/multi-framework/)** - Multiple frameworks
- **[Production Setup](examples/hello-helm/production/)** - Production-ready configuration

## Development

### Local Development

```bash
# Clone the repository
git clone https://github.com/nimishgj/helm-charts.git
cd helm-charts

# Install from local charts
helm install test-release ./charts/hello-helm -f examples/hello-helm/basic/values.yaml
```

### Testing Charts

```bash
# Lint charts
helm lint ./charts/hello-helm

# Template validation
helm template test-release ./charts/hello-helm --debug

# Dry run installation
helm install test-release ./charts/hello-helm --dry-run --debug
```

## Contributing

We welcome contributions! Please see our contribution guidelines:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Test** your changes thoroughly
4. **Document** your changes
5. **Submit** a pull request

### Chart Development Guidelines

- Follow [Helm best practices](https://helm.sh/docs/chart_best_practices/)
- Include comprehensive documentation
- Add examples for new features
- Test with different Kubernetes versions
- Update version numbers following [SemVer](https://semver.org/)

## Automated Releases

This repository uses GitHub Actions to automatically:
- Package and release charts on version changes
- Publish to GitHub Pages for Helm repository hosting
- Generate release notes and artifacts

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Documentation**: Check the [docs/](docs/) directory
- **Issues**: Open an issue on GitHub
- **Discussions**: Use GitHub Discussions for questions

## Roadmap

- [ ] Additional chart types (databases, monitoring)
- [ ] Advanced networking configurations
- [ ] Multi-cluster deployment examples
- [ ] Integration with service mesh