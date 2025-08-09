{{/*
Expand the name of the chart.
*/}}
{{- define "hello-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "hello-helm.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "hello-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hello-helm.labels" -}}
helm.sh/chart: {{ include "hello-helm.chart" . }}
{{ include "hello-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.global.labels }}
{{- toYaml . | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hello-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Framework-specific helper functions
*/}}

{{/*
Go/Gin specific name
*/}}
{{- define "hello-helm.go-gin.fullname" -}}
{{- printf "%s-go-gin" (include "hello-helm.fullname" .) }}
{{- end }}

{{/*
Go/Gin labels
*/}}
{{- define "hello-helm.go-gin.labels" -}}
{{ include "hello-helm.labels" . }}
app.kubernetes.io/component: go-gin
framework: gin
language: go
{{- end }}

{{/*
Go/Gin selector labels
*/}}
{{- define "hello-helm.go-gin.selectorLabels" -}}
{{ include "hello-helm.selectorLabels" . }}
app.kubernetes.io/component: go-gin
{{- end }}

{{/*
Java/SpringBoot specific name
*/}}
{{- define "hello-helm.java-springboot.fullname" -}}
{{- printf "%s-java-springboot" (include "hello-helm.fullname" .) }}
{{- end }}

{{/*
Java/SpringBoot labels
*/}}
{{- define "hello-helm.java-springboot.labels" -}}
{{ include "hello-helm.labels" . }}
app.kubernetes.io/component: java-springboot
framework: springboot
language: java
{{- end }}

{{/*
Java/SpringBoot selector labels
*/}}
{{- define "hello-helm.java-springboot.selectorLabels" -}}
{{ include "hello-helm.selectorLabels" . }}
app.kubernetes.io/component: java-springboot
{{- end }}

{{/*
Node.js/Express specific name
*/}}
{{- define "hello-helm.nodejs-express.fullname" -}}
{{- printf "%s-nodejs-express" (include "hello-helm.fullname" .) }}
{{- end }}

{{/*
Node.js/Express labels
*/}}
{{- define "hello-helm.nodejs-express.labels" -}}
{{ include "hello-helm.labels" . }}
app.kubernetes.io/component: nodejs-express
framework: express
language: nodejs
{{- end }}

{{/*
Node.js/Express selector labels
*/}}
{{- define "hello-helm.nodejs-express.selectorLabels" -}}
{{ include "hello-helm.selectorLabels" . }}
app.kubernetes.io/component: nodejs-express
{{- end }}

{{/*
Python/FastAPI specific name
*/}}
{{- define "hello-helm.python-fastapi.fullname" -}}
{{- printf "%s-python-fastapi" (include "hello-helm.fullname" .) }}
{{- end }}

{{/*
Python/FastAPI labels
*/}}
{{- define "hello-helm.python-fastapi.labels" -}}
{{ include "hello-helm.labels" . }}
app.kubernetes.io/component: python-fastapi
framework: fastapi
language: python
{{- end }}

{{/*
Python/FastAPI selector labels
*/}}
{{- define "hello-helm.python-fastapi.selectorLabels" -}}
{{ include "hello-helm.selectorLabels" . }}
app.kubernetes.io/component: python-fastapi
{{- end }}

{{/*
PHP/Laravel specific name
*/}}
{{- define "hello-helm.php-laravel.fullname" -}}
{{- printf "%s-php-laravel" (include "hello-helm.fullname" .) }}
{{- end }}

{{/*
PHP/Laravel labels
*/}}
{{- define "hello-helm.php-laravel.labels" -}}
{{ include "hello-helm.labels" . }}
app.kubernetes.io/component: php-laravel
framework: laravel
language: php
{{- end }}

{{/*
PHP/Laravel selector labels
*/}}
{{- define "hello-helm.php-laravel.selectorLabels" -}}
{{ include "hello-helm.selectorLabels" . }}
app.kubernetes.io/component: php-laravel
{{- end }}

{{/*
Generate image name
*/}}
{{- define "hello-helm.image" -}}
{{- $registry := .Values.global.imageRegistry -}}
{{- $repository := .Values.global.imageRepository -}}
{{- $name := .name -}}
{{- $tag := .Values.global.imageTag | toString -}}
{{- printf "%s/%s/%s:%s" $registry $repository $name $tag -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hello-helm.serviceAccountName" -}}
{{- if .Values.common.serviceAccount.create }}
{{- default (include "hello-helm.fullname" .) .Values.common.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.common.serviceAccount.name }}
{{- end }}
{{- end }}