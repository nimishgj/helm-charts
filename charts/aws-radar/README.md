# AWS Radar Helm Chart

A Helm chart for deploying [AWS Radar](https://github.com/nimishgj/aws-radar) — a lightweight AWS resource monitoring agent that collects resource counts across 29 AWS services and exposes Prometheus metrics.

**Source Code**: [github.com/nimishgj/aws-radar](https://github.com/nimishgj/aws-radar)

**Container Image**: `ghcr.io/nimishgj/aws-radar`

## Features

- **Multi-instance**: Deploy multiple aws-radar instances with a single Helm install
- **Per-instance Config**: Each instance gets its own AWS credentials, regions, and collector settings
- **Common Defaults**: Shared defaults inherited by all instances, override only what you need
- **29 AWS Collectors**: EC2, S3, Lambda, RDS, ECS, EKS, DynamoDB, VPC, and more

## Quick Start

### Single instance
```bash
helm install aws-radar ./charts/aws-radar \
  --set 'instances[0].name=my-account' \
  --set 'instances[0].awsAccessKeyId=AKIA...' \
  --set 'instances[0].awsSecretAccessKey=...' \
  --set 'instances[0].aws.regions[0]=us-east-1'
```

### Multiple instances
```bash
helm install aws-radar ./charts/aws-radar -f my-values.yaml
```

```yaml
# my-values.yaml
instances:
  - name: prod
    awsAccessKeyId: AKIA...
    awsSecretAccessKey: ...
    aws:
      regions:
        - us-east-1
        - eu-west-1

  - name: dev
    awsAccessKeyId: AKIA...
    awsSecretAccessKey: ...
    aws:
      regions:
        - ap-south-1
    collectors:
      - ec2
      - s3
      - lambda
    collection:
      interval: 120s
```

## Configuration

### Common Defaults

All instances inherit from `common`. Override any field per instance.

```yaml
common:
  server:
    port: 9090
    metricsPath: /metrics
    healthPath: /health

  collection:
    interval: 60s              # How often to collect metrics
    timeout: 30s               # Timeout per collector

  collectors:                  # AWS services to monitor
    - ec2
    - s3
    - lambda
    - rds
    # ... all 29 collectors enabled by default

  logging:
    level: info                # info, debug, warn, error
    format: json               # json or text

  resources:
    requests:
      memory: "128Mi"
      cpu: "100m"
    limits:
      memory: "256Mi"
      cpu: "200m"

  healthCheck:
    initialDelaySeconds: 10
    periodSeconds: 30
    timeoutSeconds: 10

  service:
    type: ClusterIP
    port: 9090

  podAnnotations: {}
  nodeSelector: {}
  tolerations: []
  affinity: {}
```

### Instance Configuration

Each instance requires `name`, `awsAccessKeyId`, `awsSecretAccessKey`, and `aws.regions`. All other fields fall back to `common` defaults.

```yaml
instances:
  - name: production           # Used in resource names
    awsAccessKeyId: ""         # AWS credentials
    awsSecretAccessKey: ""
    aws:
      regions:                 # Required: AWS regions to scan
        - us-east-1

    # Optional overrides (all fall back to common):
    # collectors: [ec2, s3]
    # collection:
    #   interval: 120s
    #   timeout: 45s
    # logging:
    #   level: debug
    # resources:
    #   limits:
    #     memory: "512Mi"
    # healthCheck:
    #   initialDelaySeconds: 15
    # service:
    #   type: LoadBalancer
    # podAnnotations:
    #   prometheus.io/scrape: "true"
    # nodeSelector: {}
    # tolerations: []
    # affinity: {}
```

### Image Configuration

```yaml
image:
  repository: ghcr.io/nimishgj/aws-radar
  tag: "0.1.1"
  pullPolicy: IfNotPresent
```

## What Gets Created

For each instance, the chart creates:

| Resource | Name Pattern | Description |
|---|---|---|
| Deployment | `{release}-aws-radar-{instance}` | Runs the aws-radar agent |
| Service | `{release}-aws-radar-{instance}` | Exposes `/metrics` and `/health` |
| ConfigMap | `{release}-aws-radar-{instance}` | Application config.yaml |
| Secret | `{release}-aws-radar-{instance}` | AWS credentials |

## Endpoints

Each instance exposes:

- `GET /metrics` — Prometheus metrics
- `GET /health` — Health check (returns `OK`)

### Port Forwarding
```bash
kubectl port-forward service/{release}-aws-radar-{instance} 9090:9090
curl http://localhost:9090/metrics
curl http://localhost:9090/health
```

## Supported AWS Collectors

`apigateway`, `apigatewayv2`, `autoscaling`, `athena`, `ecr`, `ec2`, `efs`, `eventbridge`, `glue`, `s3`, `rds`, `lambda`, `ecs`, `elb`, `eks`, `dynamodb`, `elasticache`, `opensearch`, `secretsmanager`, `sfn`, `ssm`, `sqs`, `sns`, `ebs`, `vpc`, `acm`, `cloudfront`, `route53`, `iam`

## Monitoring

```bash
# Check all aws-radar pods
kubectl get pods -l app.kubernetes.io/name=aws-radar

# Check a specific instance
kubectl get pods -l app.kubernetes.io/component=production

# View logs
kubectl logs -l app.kubernetes.io/component=production
```

## Troubleshooting

```bash
# Validate chart
helm lint ./charts/aws-radar

# Dry run
helm template test ./charts/aws-radar -f my-values.yaml

# Check pod events
kubectl describe pod -l app.kubernetes.io/component=production
```

## Chart Info

| | |
|---|---|
| Chart Version | 0.1.0 |
| App Version | 0.1.1 |
| Kubernetes | >= 1.19.0 |
| Source Code | [github.com/nimishgj/aws-radar](https://github.com/nimishgj/aws-radar) |
