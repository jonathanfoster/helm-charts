{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hoppscotch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Returns a default init container that waits for the database to be ready.
*/}}
{{- define "hoppscotch.defaultInitContainers.waitForDatabase" -}}
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
        name: {{ include "hoppscotch.secretName" . }}
{{- end -}}

{{/*
Create a fully qualified name that includes the release name and chart name.
*/}}
{{- define "hoppscotch.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $releaseName := regexReplaceAll "(-?[^a-z\\d\\-])+-?" (lower .Release.Name) "-" -}}
{{- if contains $name $releaseName -}}
{{- $releaseName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" $releaseName $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

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
Return common labels for all resources.
*/}}
{{- define "hoppscotch.labels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ include "hoppscotch.name" . }}
app.kubernetes.io/part-of: {{ template "hoppscotch.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
helm.sh/chart: {{ include "hoppscotch.chart" . }}
{{- if .Values.commonLabels}}
{{ toYaml .Values.commonLabels }}
{{- end }}
{{- end -}}

{{/*
Allow the chart name to be overridden.
*/}}
{{- define "hoppscotch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Allow the release namespace to be overridden.
*/}}
{{- define "hoppscotch.namespace" -}}
{{- default .Release.Namespace .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the PVC claim name to use.
*/}}
{{- define "hoppscotch.pvc.claimName" -}}
{{- if .Values.persistence.existingClaim }}
{{- .Values.persistence.existingClaim }}
{{- else }}
{{- include "hoppscotch.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return the secret name to use for environment variables.
*/}}
{{- define "hoppscotch.secretName" -}}
{{- if .Values.existingSecret }}
{{- .Values.existingSecret }}
{{- else }}
{{- include "hoppscotch.fullname" . }}
{{- end }}
{{- end }}

{{/*
Return the database URL based on the PostgreSQL chart or external database settings
*/}}
{{- define "hoppscotch.secret.databaseUrl" -}}
{{- if .Values.postgresql.enabled -}}
{{- $host := printf "%s-postgresql.%s.svc.%s" .Release.Name .Release.Namespace .Values.clusterDomain -}}
{{- $port := 5432 -}}
{{- $user := .Values.postgresql.auth.username -}}
{{- $database := .Values.postgresql.auth.database -}}
{{- $password := .Values.postgresql.auth.password -}}
{{- if not $password -}}
{{- $postgresSecretName := printf "%s-postgresql" .Release.Name -}}
{{- $password = include "hoppscotch.secret.lookupValue" (dict "name" $postgresSecretName "namespace" .Release.Namespace "key" "password") -}}
{{- end -}}
{{- include "hoppscotch.secret.formatPostgresUrl" (dict "host" $host "port" $port "user" $user "password" $password "database" $database) -}}
{{- else if .Values.externalDatabase.sqlConnection -}}
{{- .Values.externalDatabase.sqlConnection -}}
{{- else -}}
{{- $host := .Values.externalDatabase.host -}}
{{- $port := .Values.externalDatabase.port | default 5432 | int -}}
{{- $user := .Values.externalDatabase.user -}}
{{- $database := .Values.externalDatabase.database -}}
{{- $password := .Values.externalDatabase.password -}}
{{- include "hoppscotch.secret.formatPostgresUrl" (dict "host" $host "port" $port "user" $user "password" $password "database" $database) -}}
{{- end -}}
{{- end -}}

{{/*
Format a database URL for use in configuration files.
Usage: {{- include "hoppscotch.secret.formatPostgresUrl" (dict "host" $host "port" $port "user" $user "password" $password "database" $database "params" $params) -}}
*/}}
{{- define "hoppscotch.secret.formatPostgresUrl" -}}
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
{{- $hostspec = printf "%s:%d" .host .port -}}
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
Return the value of a secret key. An empty string is returned if the key is not found.
Usage: {{- include "hoppscotch.secret.lookupValue" (dict "name" "my-secret" "namespace" "my-namespace" "key" "my-key") -}}
*/}}
{{- define "hoppscotch.secret.lookupValue" -}}
{{- $secret := (lookup "v1" "Secret" .namespace .name) -}}
{{- if and $secret $secret.data (hasKey $secret.data .key) -}}
{{- index $secret.data .key | b64dec | trimAll "\n" -}}
{{- end -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hoppscotch.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "hoppscotch.name" . }}
{{- end }}

{{/*
Return the service account name to use.
*/}}
{{- define "hoppscotch.serviceAccount.name" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hoppscotch.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate the base URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.baseUrl" -}}
{{- if .Values.frontend.baseUrl -}}
{{- .Values.frontend.baseUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end }}

{{/*
Generate the shortcode base URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.shortcodeBaseUrl" -}}
{{- if .Values.frontend.shortcodeBaseUrl -}}
{{- .Values.frontend.shortcodeBaseUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end }}

{{/*
Generate the admin URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.adminUrl" -}}
{{- if .Values.frontend.adminUrl -}}
{{- .Values.frontend.adminUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- if .Values.frontend.enableSubpathBasedAccess -}}
{{- printf "%s://%s/admin" $scheme .Values.ingress.hostname -}}
{{- else -}}
{{- printf "%s://%s/admin" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate the backend GraphQL URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.backendGqlUrl" -}}
{{- if .Values.frontend.backendGqlUrl -}}
{{- .Values.frontend.backendGqlUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- if .Values.frontend.enableSubpathBasedAccess -}}
{{- printf "%s://%s/backend/graphql" $scheme .Values.ingress.hostname -}}
{{- else -}}
{{- printf "%s://%s/backend/graphql" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate the backend WebSocket URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.backendWsUrl" -}}
{{- if .Values.frontend.backendWsUrl -}}
{{- .Values.frontend.backendWsUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "ws" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "wss" -}}
{{- end -}}
{{- if .Values.frontend.enableSubpathBasedAccess -}}
{{- printf "%s://%s/backend/graphql" $scheme .Values.ingress.hostname -}}
{{- else -}}
{{- printf "%s://%s/backend/graphql" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate the backend API URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.backendApiUrl" -}}
{{- if .Values.frontend.backendApiUrl -}}
{{- .Values.frontend.backendApiUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- if .Values.frontend.enableSubpathBasedAccess -}}
{{- printf "%s://%s/backend/v1" $scheme .Values.ingress.hostname -}}
{{- else -}}
{{- printf "%s://%s/backend/v1" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate the redirect URL for the backend based on ingress configuration
*/}}
{{- define "hoppscotch.backend.redirectUrl" -}}
{{- if .Values.backend.redirectUrl -}}
{{- .Values.backend.redirectUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end }}

{{/*
Generate whitelisted origins for the backend based on ingress configuration
*/}}
{{- define "hoppscotch.backend.whitelistedOrigins" -}}
{{- if .Values.backend.whitelistedOrigins -}}
{{- .Values.backend.whitelistedOrigins | join "," -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- printf "%s,%s/admin,%s/backend,app://hoppscotch" $baseUrl $baseUrl $baseUrl -}}
{{- end -}}
{{- end }}

{{/*
Generate Google auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.google.callbackUrl" -}}
{{- if .Values.backend.auth.google.callbackUrl -}}
{{- .Values.backend.auth.google.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/google/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/google/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate GitHub auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.github.callbackUrl" -}}
{{- if .Values.backend.auth.github.callbackUrl -}}
{{- .Values.backend.auth.github.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/github/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/github/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate Microsoft auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.microsoft.callbackUrl" -}}
{{- if .Values.backend.auth.microsoft.callbackUrl -}}
{{- .Values.backend.auth.microsoft.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/microsoft/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/microsoft/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate SAML auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.saml.callbackUrl" -}}
{{- if .Values.backend.auth.saml.callbackUrl -}}
{{- .Values.backend.auth.saml.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/saml/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/saml/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate OIDC auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.oidc.callbackUrl" -}}
{{- if .Values.backend.auth.oidc.callbackUrl -}}
{{- .Values.backend.auth.oidc.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/oidc/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/oidc/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Return the Redis URL based on the Redis chart or external Redis settings
*/}}
{{- define "hoppscotch.secret.redisUrl" -}}
{{- if .Values.redis.enabled -}}
{{- $host := printf "%s-redis-master.%s.svc.%s" .Release.Name .Release.Namespace .Values.clusterDomain -}}
{{- $port := 6379 -}}
{{- $password := .Values.redis.auth.password -}}
{{- if not $password -}}
{{- $redisSecretName := printf "%s-redis" .Release.Name -}}
{{- $password = include "hoppscotch.secret.lookupValue" (dict "name" $redisSecretName "namespace" .Release.Namespace "key" "redis-password") -}}
{{- end -}}
{{- include "hoppscotch.secret.formatRedisUrl" (dict "host" $host "port" $port "password" $password) -}}
{{- else -}}
{{- $host := .Values.externalRedis.host -}}
{{- $port := .Values.externalRedis.port | default 6379 | int -}}
{{- $password := .Values.externalRedis.password -}}
{{- include "hoppscotch.secret.formatRedisUrl" (dict "host" $host "port" $port "password" $password) -}}
{{- end -}}
{{- end -}}

{{/*
Format a Redis URL for use in configuration files.
Usage: {{- include "hoppscotch.secret.formatRedisUrl" (dict "host" $host "port" $port "password" $password) -}}
*/}}
{{- define "hoppscotch.secret.formatRedisUrl" -}}
{{- $authspec := "" -}}
{{- $hostspec := .host -}}
{{- if .password -}}
{{- $authspec = printf ":%s@" .password -}}
{{- end -}}
{{- if .port -}}
{{- $hostspec = printf "%s:%d" .host .port -}}
{{- end -}}
{{- printf "redis://%s%s" $authspec $hostspec -}}
{{- end -}}
