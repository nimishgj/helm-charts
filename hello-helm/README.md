# Hello Frameworks Helm Chart

A comprehensive Helm chart for deploying multi-framework REST API applications on Kubernetes. This chart supports conditional deployment of applications built with different frameworks and languages.

## Supported Frameworks

- **Go/Gin** - `ghcr.io/nimishgj/hello-gin:latest`
- **Java/SpringBoot** - `ghcr.io/nimishgj/hello-springboot:latest`
- **Node.js/Express** - `ghcr.io/nimishgj/hello-express:latest`
- **Python/FastAPI** - `ghcr.io/nimishgj/hello-fastapi:latest`
- **PHP/Laravel** - `ghcr.io/nimishgj/hello-laravel:latest`

## Features

- **Conditional Deployment**: Enable/disable individual frameworks
- **Consistent API**: All applications expose the same REST endpoints
- **Production Ready**: Includes health checks, resource limits, and security contexts
- **Configurable**: Customizable replicas, resources, and service settings
- **Kubernetes Best Practices**: Proper labeling, security contexts, and probe configurations

## Quick Start

### Install with Go/Gin only (default)
```bash
helm install my-apps ./hello-helm
```

### Install multiple frameworks
```bash
helm install my-apps ./hello-helm \
  --set goGin.enabled=true \
  --set javaSpringboot.enabled=true \
  --set nodejsExpress.enabled=true
```

### Install all frameworks
```bash
helm install my-apps ./hello-helm \
  --set goGin.enabled=true \
  --set javaSpringboot.enabled=true \
  --set nodejsExpress.enabled=true \
  --set pythonFastapi.enabled=true \
  --set phpLaravel.enabled=true
```

## Configuration

### Framework Control

Each framework can be enabled/disabled independently:

```yaml
# Default configuration (only Go/Gin enabled)
goGin:
  enabled: true      # Enable/disable Go/Gin deployment

javaSpringboot:
  enabled: false     # Enable/disable Java/SpringBoot deployment

nodejsExpress:
  enabled: false     # Enable/disable Node.js/Express deployment

pythonFastapi:
  enabled: false     # Enable/disable Python/FastAPI deployment

phpLaravel:
  enabled: false     # Enable/disable PHP/Laravel deployment
```

### Framework-specific Configuration

Each framework supports individual configuration:

```yaml
goGin:
  enabled: true
  replicas: 3                    # Number of pod replicas
  image:
    name: hello-gin              # Docker image name
    targetPort: 8080             # Container port
  resources:
    requests:
      memory: "64Mi"
      cpu: "50m"
    limits:
      memory: "128Mi"
      cpu: "100m"
  healthCheck:
    path: /api/health            # Health check endpoint
    port: 8080
    initialDelaySeconds: 10
    periodSeconds: 10
    timeoutSeconds: 5
  service:
    type: ClusterIP             # Service type
    port: 80                    # Service port
```

### Global Configuration

Configure settings applied to all frameworks:

```yaml
global:
  imageRegistry: ghcr.io        # Container registry
  imageRepository: nimishgj     # Repository name
  imageTag: latest              # Image tag
  imagePullPolicy: IfNotPresent
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 2000
```

### Common Configuration

Settings that can be applied to all enabled frameworks:

```yaml
common:
  podAnnotations: {}           # Additional pod annotations
  nodeSelector: {}             # Node selector constraints
  tolerations: []              # Pod tolerations
  affinity: {}                 # Pod affinity rules
  serviceAccount:
    create: false              # Create service account
    name: ""                   # Service account name
```

## Usage Examples

### Development Environment
Deploy only lightweight frameworks for development:
```bash
helm install dev-apps ./hello-helm \
  --set goGin.enabled=true \
  --set nodejsExpress.enabled=true \
  --set pythonFastapi.enabled=true
```

### Production Environment
Deploy with custom resources and multiple replicas:
```bash
helm install prod-apps ./hello-helm \
  --set goGin.enabled=true \
  --set goGin.replicas=3 \
  --set goGin.resources.requests.memory="128Mi" \
  --set goGin.resources.limits.memory="256Mi" \
  --set javaSpringboot.enabled=true \
  --set javaSpringboot.replicas=2
```

### Upgrade Deployment
Enable additional frameworks:
```bash
helm upgrade my-apps ./hello-helm \
  --set goGin.enabled=true \
  --set phpLaravel.enabled=true
```

### Custom Values File
Create a custom values file:
```yaml
# custom-values.yaml
goGin:
  enabled: true
  replicas: 2

javaSpringboot:
  enabled: true
  replicas: 1

nodejsExpress:
  enabled: true
  replicas: 3
  resources:
    requests:
      memory: "128Mi"
      cpu: "100m"
    limits:
      memory: "256Mi"
      cpu: "200m"

global:
  imageTag: v1.2.0
```

Deploy with custom values:
```bash
helm install my-apps ./hello-helm -f custom-values.yaml
```

## API Endpoints

All deployed applications expose the same REST API endpoints:

### Health Check
```bash
GET /api/health
```

Response:
```json
{
  "status": "healthy",
  "timestamp": 1673123456,
  "service": "go-gin-api-server"
}
```

### User Management
```bash
GET    /api/users          # List all users
GET    /api/users/{id}     # Get user by ID
POST   /api/users          # Create new user
PUT    /api/users/{id}     # Update user
DELETE /api/users/{id}     # Delete user
```

## Accessing Services

### Using kubectl port-forward
```bash
# Forward Go/Gin service
kubectl port-forward service/my-apps-hello-frameworks-go-gin 8080:80

# Forward Java/SpringBoot service  
kubectl port-forward service/my-apps-hello-frameworks-java-springboot 8081:80

# Test the API
curl http://localhost:8080/api/health
curl http://localhost:8081/api/users
```

### Using Ingress
```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-frameworks-ingress
spec:
  rules:
  - host: go-gin.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-apps-hello-frameworks-go-gin
            port:
              number: 80
  - host: java-spring.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-apps-hello-frameworks-java-springboot
            port:
              number: 80
```

## Monitoring and Observability

### Resource Monitoring
```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/part-of=hello-frameworks

# Check resource usage
kubectl top pods -l app.kubernetes.io/part-of=hello-frameworks

# View logs
kubectl logs -l app.kubernetes.io/component=go-gin
```

### Health Check Monitoring
```bash
# Check deployment health
kubectl get deployments -l app.kubernetes.io/part-of=hello-frameworks

# Describe pods for health check status
kubectl describe pods -l app.kubernetes.io/component=java-springboot
```

## Troubleshooting

### Common Issues

1. **Image Pull Errors**
   ```bash
   # Check if images are accessible
   kubectl describe pod <pod-name>
   
   # Verify image exists
   docker pull ghcr.io/nimishgj/hello-gin:latest
   ```

2. **Health Check Failures**
   ```bash
   # Check health check configuration
   helm get values my-apps
   
   # Test health endpoint directly
   kubectl port-forward pod/<pod-name> 8080:8080
   curl http://localhost:8080/api/health
   ```

3. **Template Issues**
   ```bash
   # Dry run to check templates
   helm template my-apps ./hello-helm --debug
   
   # Validate chart
   helm lint ./hello-helm
   ```

### Debugging Commands
```bash
# Get all resources
kubectl get all -l app.kubernetes.io/part-of=hello-frameworks

# Check events
kubectl get events --field-selector involvedObject.kind=Pod

# View detailed pod information
kubectl describe pod -l app.kubernetes.io/component=python-fastapi
```

## Chart Information

- **Chart Version**: 0.1.0
- **App Version**: 1.0.0
- **Kubernetes Version**: >= 1.19.0

## Contributing

1. Make changes to templates or values
2. Test with `helm lint` and `helm template`
3. Verify with actual deployment
4. Update documentation

## License

This chart is provided as-is for demonstration purposes.