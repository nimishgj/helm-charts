# Documentation

This directory contains comprehensive documentation for the Helm charts in this repository.

## Structure

```
docs/
├── charts/
│   ├── hello-helm/           # Chart-specific documentation
│   │   ├── configuration.md  # Configuration reference
│   │   ├── examples.md       # Usage examples
│   │   └── troubleshooting.md # Common issues and solutions
│   └── [other-charts]/
├── guides/
│   ├── getting-started.md    # Quick start guide
│   ├── production-deployment.md # Production best practices
│   └── development-setup.md  # Development environment setup
├── api/
│   └── rest-api.md          # API documentation for deployed services
└── README.md
```

## Quick Links

- [Getting Started Guide](guides/getting-started.md)
- [Hello-Helm Chart Documentation](charts/hello-helm/)
- [REST API Reference](api/rest-api.md)
- [Production Deployment Guide](guides/production-deployment.md)

## Contributing to Documentation

When adding new charts or features:

1. Create chart-specific documentation in `docs/charts/[chart-name]/`
2. Update the main README and getting started guide
3. Add examples to the `examples/` directory
4. Include API documentation if applicable