{{/*
Expand the name of the chart.
*/}}
{{- define "hoppscotch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hoppscotch.fullname" -}}
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
{{- define "hoppscotch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hoppscotch.labels" -}}
helm.sh/chart: {{ include "hoppscotch.chart" . }}
{{ include "hoppscotch.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hoppscotch.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hoppscotch.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hoppscotch.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hoppscotch.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate the database URL from PostgreSQL chart or external database settings
*/}}
{{- define "hoppscotch.databaseUrl" -}}
{{- if .Values.postgresql.enabled -}}
{{- $host := printf "%s-postgresql.%s.svc.%s" (include "hoppscotch.fullname" .) .Release.Namespace .Values.clusterDomain -}}
{{- $port := 5432 -}}
{{- $user := .Values.postgresql.auth.username -}}
{{- $database := .Values.postgresql.auth.database -}}
{{- $password := .Values.postgresql.auth.password | default "" -}}
{{- printf "postgres://%s:%s@%s:%v/%s?sslmode=disable" $user $password $host $port $database -}}
{{- else if .Values.externalDatabase.sqlConnection -}}
{{- .Values.externalDatabase.sqlConnection -}}
{{- else -}}
{{- $host := .Values.externalDatabase.host -}}
{{- $port := .Values.externalDatabase.port | default 5432 | int -}}
{{- $user := .Values.externalDatabase.user -}}
{{- $database := .Values.externalDatabase.database -}}
{{- $password := .Values.externalDatabase.password -}}
{{- printf "postgres://%s:%s@%s:%v/%s?sslmode=disable" $user $password $host $port $database -}}
{{- end -}}
{{- end }}
