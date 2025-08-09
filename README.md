# Helm Charts Repository

A collection of Helm charts for deploying applications on Kubernetes.

## Charts

### hello-helm

A comprehensive Helm chart for deploying multi-framework REST API applications on Kubernetes. This chart supports conditional deployment of applications built with different frameworks and languages.

**Supported Frameworks:**
- Go/Gin
- Java/SpringBoot
- Node.js/Express
- Python/FastAPI
- PHP/Laravel

**Features:**
- Conditional deployment (enable/disable individual frameworks)
- Production-ready configurations
- Health checks and resource management
- Kubernetes best practices
- Consistent API across all frameworks

## Quick Start

### Prerequisites

- Kubernetes cluster (>= 1.19.0)
- Helm 3.x installed
- kubectl configured to access your cluster

### Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd helm-charts
```

2. Install a chart (example with Go/Gin only):
```bash
helm install my-apps ./hello-helm
```

3. Install with multiple frameworks:
```bash
helm install my-apps ./hello-helm \
  --set goGin.enabled=true \
  --set javaSpringboot.enabled=true \
  --set nodejsExpress.enabled=true
```

### Accessing Services

Use kubectl port-forward to access services locally:
```bash
kubectl port-forward service/my-apps-hello-helm-go-gin 8080:80
curl http://localhost:8080/api/health
```

## Chart Development

### Testing Charts

```bash
# Lint charts
helm lint ./hello-helm

# Dry run
helm template test-release ./hello-helm --debug

# Install in test mode
helm install test-release ./hello-helm --dry-run --debug
```

### Chart Structure

```
hello-helm/
├── Chart.yaml          # Chart metadata
├── values.yaml         # Default configuration values
├── README.md          # Chart-specific documentation
└── templates/         # Kubernetes manifest templates
    ├── _helpers.tpl   # Template helpers
    ├── deployments/   # Deployment templates
    └── services/      # Service templates
```

## API Endpoints

All deployed applications expose consistent REST API endpoints:

- `GET /api/health` - Health check
- `GET /api/users` - List users
- `GET /api/users/{id}` - Get user by ID
- `POST /api/users` - Create user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test your charts
5. Submit a pull request

### Guidelines

- Follow Helm best practices
- Include comprehensive documentation
- Test all changes
- Update version numbers appropriately

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue in this repository.