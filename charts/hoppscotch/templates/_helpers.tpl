{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hoppscotch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Generate the database URL from PostgreSQL chart or external database settings
*/}}
{{- define "hoppscotch.databaseUrl" -}}
{{- if .Values.postgresql.enabled -}}
{{- $host := printf "%s-postgresql.%s.svc.%s" .Release.Name .Release.Namespace .Values.clusterDomain -}}
{{- $port := 5432 -}}
{{- $user := .Values.postgresql.auth.username -}}
{{- $database := .Values.postgresql.auth.database -}}
{{- $password := .Values.postgresql.auth.password -}}
{{- if not $password -}}
{{- $postgresSecretName := printf "%s-postgresql" .Release.Name -}}
{{- $password = include "hoppscotch.lookupSecret" (dict "name" $postgresSecretName "namespace" .Release.Namespace "key" "password") -}}
{{- end -}}
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

Usage: {{- include "hoppscotch.formatDatabaseUrl" (dict "host" $host "port" $port "user" $user "password" $password "database" $database "params" $params) -}}

Params:
  - host - The host of the database (required)
  - port - The port of the database (default 5432)
  - user - The username for the database
  - password - The password for the database
  - database - The name of the database
  - params - Additional parameters to append to the URL
*/}}
{{- define "hoppscotch.formatDatabaseUrl" -}}
{{- $userspec := "" -}}
{{- $hostspec := .host -}}
{{- $dbname := "" -}}
{{- $paramspec := "" -}}
{{- if and .user .password -}}
{{- $userspec = printf "%s:%s@" .user .password -}}
{{- else if .user -}}
{{- $userspec = printf "%s@" .user -}}
{{- end -}}
{{- if .port -}}
{{- $hostspec = printf "%s:%d" .host (default 5432 .port) -}}
{{- end -}}
{{- if .database -}}
{{- $dbname = printf "/%s" .database -}}
{{- end -}}
{{- if .params -}}
{{- $paramspec = printf "?%s" .params -}}
{{- end -}}
{{- printf "postgres://%s%s%s%s" $userspec $hostspec $dbname $paramspec -}}
{{- end -}}

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
Create the image name and tag. Chart app version is used as a default tag if not specified.
*/}}
{{- define "hoppscotch.image" -}}
{{- printf "%s:%s" .Values.image.repository (default .Chart.AppVersion .Values.image.tag) -}}
{{- end -}}

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Usage: {{ include "hoppscotch.ingress.certManagerRequest" ( dict "annotations" .Values.path.to.the.ingress.annotations ) }}
*/}}
{{- define "hoppscotch.ingress.certManagerRequest" -}}
{{ if or (hasKey .annotations "cert-manager.io/cluster-issuer") (hasKey .annotations "cert-manager.io/issuer") (hasKey .annotations "kubernetes.io/tls-acme") }}
    {{- true -}}
{{- end -}}
{{- end -}}

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
Lookup a secret value by key. An empty string is returned if the key is not found.

Usage: {{- include "hoppscotch.lookupSecret" (dict "name" "my-secret" "namespace" "my-namespace" "key" "my-key") -}}

Params:
  - name - The name of the secret (required)
  - namespace - The namespace of the secret (required)
  - key - The key in the secret data to lookup (required)
*/}}
{{- define "hoppscotch.lookupSecret" -}}
{{- $secret := (lookup "v1" "Secret" .namespace .name) -}}
{{- if and $secret $secret.data (hasKey $secret.data .key) -}}
{{- index $secret.data .key | b64dec | trimAll "\n" -}}
{{- end -}}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "hoppscotch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
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
Returns a default init container that waits for the database to be ready.
*/}}
{{- define "hoppscotch.waitForDatabaseInitContainer" -}}
- name: wait-for-db
  image: postgres:16-alpine
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  command:
    - /bin/sh
  args:
    - -c
    - |
      end_time=$(($(date +%s) + $0))
      until pg_isready -d $DATABASE_URL; do
        if [ $(date +%s) -ge $end_time ]; then
          exit 1
        fi
        sleep 2
      done
    - {{ .Values.defaultInitContainers.waitForDatabase.timeout | default 60 | quote}}
  {{- with .Values.extraEnvs }}
  env:
    {{- tpl (toYaml .) . | nindent 12 }}
  {{- end }}
  envFrom:
    - secretRef:
        name: {{ include "hoppscotch.fullname" . }}
{{- end -}}
