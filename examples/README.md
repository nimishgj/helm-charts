# Examples

This directory contains example configurations and deployments for the Helm charts in this repository.

## Structure

```
examples/
├── hello-helm/
│   ├── basic/                 # Basic deployment examples
│   ├── production/           # Production-ready configurations
│   ├── multi-framework/      # Multiple frameworks enabled
│   └── custom-values/        # Custom value file examples
└── README.md
```

## Usage

Each subdirectory contains example values files and deployment scripts that demonstrate different use cases for the charts.

To use an example:

```bash
# Using an example values file
helm install my-release ../charts/hello-helm -f hello-helm/basic/values.yaml

# Or copy and modify the values
cp hello-helm/production/values.yaml my-custom-values.yaml
# Edit my-custom-values.yaml as needed
helm install my-release ../charts/hello-helm -f my-custom-values.yaml
```