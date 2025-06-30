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
{{- include "hoppscotch.formatDatabaseUrl" (dict "host" $host "port" $port "user" $user "password" $password "database" $database) -}}
{{- else if .Values.externalDatabase.sqlConnection -}}
{{- .Values.externalDatabase.sqlConnection -}}
{{- else -}}
{{- $host := .Values.externalDatabase.host -}}
{{- $port := .Values.externalDatabase.port | default 5432 | int -}}
{{- $user := .Values.externalDatabase.user -}}
{{- $database := .Values.externalDatabase.database -}}
{{- $password := .Values.externalDatabase.password -}}
{{- include "hoppscotch.formatDatabaseUrl" (dict "host" $host "port" $port "user" $user "password" $password "database" $database) -}}
{{- end -}}
{{- end }}

{{/*
Format a database URL for use in configuration files.

Useage: {{- include "hoppscotch.formatDatabaseUrl" (dict "host" $host "port" $port "user" $user "password" $password "database" $database) -}}

Params:
  - host - String - Required - The host of the database.
  - port - Integer - Optional - The port of the database. Defaults to 5432.
  - user - String - Optional - The username for the database.
  - password - String - Optional - The password for the database, defaults to empty string.
  - database - String - Optional - The name of the database.
  - params - String - Optional - Additional parameters to append to the URL.
*/}}
{{- define "hoppscotch.formatDatabaseUrl" -}}
{{- $protocol := "postgres://" -}}
{{- $userspec := "" -}}
{{- $hostspec := "" -}}
{{- $dbname := "" -}}
{{- $paramspec := "" -}}
{{- if and .user .password -}}
{{- $userspec = printf "%s:%s@" .user .password -}}
{{- else if .user -}}
{{- $userspec = printf "%s@" .user -}}
{{- else -}}
{{- $userspec = "" -}}
{{- end -}}
{{- if .port -}}
{{- $hostspec = printf "%s:%d" .host (default 5432 .port) -}}
{{- else -}}
{{- $hostspec = printf "%s" .host -}}
{{- end -}}
{{- if .database -}}
{{- $dbname = printf "/%s" .database -}}
{{- end -}}
{{- if .params -}}
{{- $paramspec = printf "?%s" .params -}}
{{- end -}}
{{- printf "postgres://%s%s%s%s" $userspec $hostspec $dbname $paramspec -}}
{{- end -}}

