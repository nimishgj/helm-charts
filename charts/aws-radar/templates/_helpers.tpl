{{/*
Chart name, truncated to 63 characters.
*/}}
{{- define "aws-radar.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified release name, truncated to 63 characters.
*/}}
{{- define "aws-radar.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Instance-scoped fullname: {release}-{chart}-{instance}
*/}}
{{- define "aws-radar.instanceName" -}}
{{- $base := include "aws-radar.fullname" .root }}
{{- printf "%s-%s" $base .instance.name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Chart label value.
*/}}
{{- define "aws-radar.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "aws-radar.labels" -}}
helm.sh/chart: {{ include "aws-radar.chart" .root }}
app.kubernetes.io/name: {{ include "aws-radar.name" .root }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
app.kubernetes.io/component: {{ .instance.name }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "aws-radar.selectorLabels" -}}
app.kubernetes.io/name: {{ include "aws-radar.name" .root }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
app.kubernetes.io/component: {{ .instance.name }}
{{- end }}
