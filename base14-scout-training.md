# Base14 Scout Training Session - 1 Hour Agenda

## **1. OpenTelemetry Foundation** *(5 minutes)*
### What is OpenTelemetry?
OpenTelemetry (OTel) is an open-source observability framework
that provides a standardized way to collect, process, and export
telemetry data (metrics, logs, and traces) from applications
and infrastructure

- **Three pillars**: Logs, Metrics, Traces
- **Vendor-neutral** - works with any backend
- **Auto-instrumentation** + custom instrumentation capabilities

### Why OpenTelemetry?
- **Unified collection**: One pipeline for all telemetry
- **Future-proof**: Industry standard, not vendor lock-in
- **Rich context**: Distributed tracing + correlated logs/metrics

## **3. Instrumentation Walkthrough Overview** *(10 minutes)*

### Live Demo Steps:
1. **Navigate to docs.base14.io**
   - Search for your framework (Java Spring Boot, Node.js, Python Flask, etc.)
   - Show auto-instrumentation options
   - Point to existing OTEL collectors in your environment
   - Show collector configuration for your specific setup

### Key Points to Emphasize:
- **Minimal code changes** required
- **Auto-instrumentation** handles most frameworks
- **Custom metrics** for business-specific insights

## **4. Scout Data Flow Architecture** *(10 minutes)*

### The Complete Journey:
Show the image in https://docs.base14.io/ homepage.
The below is just for understanding and explaining
```
[Your Apps] → [OTEL Collectors] → [Scout Backend] → [Scout Ingestor] → [Data Lake] → [Grafana Visualization]
```

### Detailed Flow Explanation :
1. **Application**: Instrumented with OpenTelemetry SDKs
2. **OTEL Collectors**: Running in your environment
   - Collect telemetry from multiple applications
   - Buffer and batch data efficiently
   - Apply processing rules and filtering
3. **Scout Proxy**: Entry point to Scout backend
   - Load balancing and routing
4. **Scout Ingestor Pipeline**:
   - Validates and processes incoming telemetry
5. **Scout Data Lake**:
   - Column-oriented storage for analytics
   - Optimized for time-series queries
   - Efficient compression and indexing

## **5. ClickHouse Schema Deep Dive** *(8 minutes)*

### Key Tables Structure:
- **Traces Table**
```
otel_traces Table
Span Identity:

Timestamp - When span started
TraceId - Unique identifier for entire trace
SpanId - Unique identifier for this span
ParentSpanId - Parent span in the trace tree
TraceState - Vendor-specific trace state

Span Metadata:

SpanName - Operation name (e.g., "GET /api/users")
SpanKind - Type of span (SERVER, CLIENT, INTERNAL, etc.)
Duration - How long span took (nanoseconds)

Context: (same patterns as other tables)

ServiceName - Service that created span
ResourceAttributes - Resource metadata
ScopeName/ScopeVersion - Instrumentation library info

Span Data:

SpanAttributes - Key-value pairs for this span (http.method, db.statement)
StatusCode - Span status (OK, ERROR, etc.)
StatusMessage - Error message if span failed

Events & Links:

Events - Nested array of timestamped events within span

Timestamp - When event occurred
Name - Event name
Attributes - Event-specific attributes


Links - References to other spans/traces

TraceId/SpanId - Target span
Attributes - Link attributes
```
- **Metrics Table**
```

otel_metrics_gauge Table
Resource Context: (same as logs)

ResourceAttributes - Resource metadata
ResourceSchemaUrl - Resource schema version
ServiceName - Service identifier

Instrumentation Context: (same as logs)

ScopeName, ScopeVersion, ScopeAttributes, ScopeDroppedAttrCount, ScopeSchemaUrl

Metric Metadata:

MetricName - Name of the metric (e.g., "cpu_usage", "memory_used")
MetricDescription - Human-readable description
MetricUnit - Unit of measurement (bytes, seconds, etc.)

Data Point:

Attributes - Key-value pairs for this specific measurement (labels/dimensions)
StartTimeUnix - When measurement period started
TimeUnix - When measurement was taken
Value - The actual gauge value (current state at point in time)
Flags - Data point flags

Exemplars:

Exemplars - Sample traces that contributed to this metric point

FilteredAttributes - Exemplar attributes
TimeUnix - When exemplar occurred
Value - Exemplar value
SpanId/TraceId - Links to trace data
```

```
otel_metrics_sum Table
Same fields as gauge PLUS:
Sum-specific Fields:

AggregationTemporality - How values are aggregated (cumulative vs delta)
IsMonotonic - Whether values only increase (like counters) or can go up/down

Use case: Counters (request_count, bytes_sent) and up/down counters (active_connections)
```

```
otel_metrics_histogram Table
Same base fields as other metrics PLUS:
Histogram-specific Fields:

Count - Total number of observations
Sum - Sum of all observed values
BucketCounts - Array of counts for each histogram bucket
ExplicitBounds - Array defining bucket boundaries
Min - Minimum observed value
Max - Maximum observed value
AggregationTemporality - Cumulative or delta aggregation

Use case: Response times, request sizes, latency distributions
```
- **Logs Table**
```
otel_logs Table
Timestamp & Time Fields:

Timestamp - High precision timestamp (nanoseconds) when log was created
TimestampTime - DateTime version for easier querying/partitioning

Tracing Context:

TraceId - Links log to a distributed trace
SpanId - Links log to specific span within trace
TraceFlags - Trace sampling flags

Log Content:

SeverityText - Human-readable severity (INFO, ERROR, DEBUG, etc.)
SeverityNumber - Numeric severity level
Body - Actual log message/content

Service Context:

ServiceName - Name of service that generated the log
ResourceAttributes - Key-value pairs describing the resource (host, container, etc.)
ResourceSchemaUrl - Schema version for resource attributes

Instrumentation Context:

ScopeName - Name of the instrumentation library
ScopeVersion - Version of instrumentation library
ScopeAttributes - Attributes of the instrumentation scope
ScopeSchemaUrl - Schema version for scope

Log-specific Data:

LogAttributes - Key-value pairs specific to this log entry
```

## **6. Grafana Data Verification** *(8 minutes)*

### Live Verification Steps:
1. **Connect to Grafana Dashboard**
2. Explain about the directory structure
3. Open Service - Resource Dashboards, tell them
   this is the entry point dashboard which gives
   them a overview of how their services are performing.
4. Click on one of the Services and show them the detailed
   trace explorer dashboard
5. Showcase Sling application.

## **7. Creating Alerts** *(10 minutes)*

### Alert Setup Walkthrough:
1. **Grafana Alert Rules**:
   - Navigate to Service - Resources Dashboard.
   - Click on the p95 dashboard and click on
     create a alert and then add evaluation expression
2. Tell them about contact points, notification policies

## **8. Q&A Session** *(16 minutes)*

### Possible Questions and Answers

question: 
ans: No

question: How does Scout handle high-cardinality metrics?
ans:

question: What's the data retention policy?
ans: By default we provide 30 days of retetnion peroid.
     but this can be increased or decreased based on the
     usage

question: Can we customize the ClickHouse schema?
ans: No, But If you tell us the usecase , we can
     work on it.

question: How do we handle sensitive data in traces?
ans: In the otel collectors running in your environment
     you can add filters, transforms to redact PII data.


**Operational Questions**:
question: What happens if collectors go down?
ans: The otel collectors cannot just go down,
       If there are any errors, it will show them
       when you start the collector, one thing that
       could happen is the memory allocated for the
       otel collector could be under given, for this
       we can create alerts like if the collectors memory
       usage is above 80% then a notification should be sent
       and actions could be taken to scale it up.

question: What happens to the data after the retention peroid?
ans: All the data will be dumped to a s3 bucket given by you.

**Advanced Use Cases**:
- "Custom business metrics examples"
- "Integration with CI/CD pipelines"
- "Multi-environment setup (dev/staging/prod)"
- "Security and compliance considerations"


## **Session Success Checklist:**
- [ ] OpenTelemetry concepts understood
- [ ] Instrumentation process explained
- [ ] Data flow architecture explained
- [ ] Data verified in Grafana
- [ ] First alert created successfully
- [ ] Key questions answered

## 

### Do's:
- Open the following websites before hand
   - https://docs.base14.io/
   - https://aps1-scout.base14.io/dpd0/dashboards
   - https://www.otelbin.io/

### Dont's:
- Do not open explore view.
- Do not open terminal or any other application.
- Only share the perticular tab or create a new window for this demo


### Otelbin.io config
```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
  resource/service-name:
    attributes:
      - key: service.name
        value: kulu
        action: upsert

      - key: environment
        value: staging
        action: upsert

  filter/drop_logs:
    error_mode: ignore
    logs:
      log_record:
        - 'IsMatch(body, ".*\bpassword:\b.*")'
        - 'ParseJSON(body)["path"] != nil'

exporters:
  otlphttp/b14:
    endpoint: otelcol:4317

extensions:
  health_check:
  pprof:
  zpages:

service:
  extensions: [health_check, pprof, zpages]
  pipelines:
    traces:
      receivers: [otlp]
      processors: [batch, resource/service-name]
      exporters: [otlphttp/b14]
    metrics:
      receivers: [otlp]
      processors: [batch, resource/service-name]
      exporters: [otlphttp/b14]
    logs:
      receivers: [otlp]
      processors: [batch, resource/service-name, filter/drop_logs]
      exporters: [otlphttp/b14]
```


