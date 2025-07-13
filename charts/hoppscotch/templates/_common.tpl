################################################################################
# Hoppscotch common partial templates
################################################################################

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hoppscotch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

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
Return the appropriate resource configuration based on resourcesPreset or custom resources
Usage: {{ include "hoppscotch.resources" (dict "preset" .Values.resourcesPreset "resources" .Values.resources) }}
*/}}
{{- define "hoppscotch.resources" -}}
{{- $preset := .preset -}}
{{- $resources := .resources -}}
{{- if $resources -}}
{{- toYaml $resources -}}
{{- else if $preset -}}
{{- include "hoppscotch.resourcesPreset" (dict "preset" $preset) -}}
{{- end -}}
{{- end -}}

{{/*
Return predefined resource configurations based on preset name
Usage: {{ include "hoppscotch.resourcesPreset" (dict "preset" .Values.resourcesPreset) }}
*/}}
{{- define "hoppscotch.resourcesPreset" -}}
{{- $preset := .preset -}}
{{- if eq $preset "nano" -}}
limits:
  cpu: 150m
  ephemeral-storage: 2Gi
  memory: 192Mi
requests:
  cpu: 100m
  ephemeral-storage: 50Mi
  memory: 128Mi
{{- else if eq $preset "micro" -}}
limits:
  cpu: 250m
  ephemeral-storage: 2Gi
  memory: 256Mi
requests:
  cpu: 125m
  ephemeral-storage: 50Mi
  memory: 192Mi
{{- else if eq $preset "small" -}}
limits:
  cpu: 500m
  ephemeral-storage: 2Gi
  memory: 512Mi
requests:
  cpu: 250m
  ephemeral-storage: 50Mi
  memory: 256Mi
{{- else if eq $preset "medium" -}}
limits:
  cpu: 1000m
  ephemeral-storage: 2Gi
  memory: 1Gi
requests:
  cpu: 500m
  ephemeral-storage: 50Mi
  memory: 512Mi
{{- else if eq $preset "large" -}}
limits:
  cpu: 2000m
  ephemeral-storage: 4Gi
  memory: 2Gi
requests:
  cpu: 1000m
  ephemeral-storage: 50Mi
  memory: 1Gi
{{- else if eq $preset "xlarge" -}}
limits:
  cpu: 4000m
  ephemeral-storage: 8Gi
  memory: 4Gi
requests:
  cpu: 2000m
  ephemeral-storage: 50Mi
  memory: 2Gi
{{- else if eq $preset "2xlarge" -}}
limits:
  cpu: 8000m
  ephemeral-storage: 16Gi
  memory: 8Gi
requests:
  cpu: 4000m
  ephemeral-storage: 50Mi
  memory: 4Gi
{{- else -}}
{{/* Default to nano if preset is not recognized */}}
limits:
  cpu: 150m
  ephemeral-storage: 2Gi
  memory: 192Mi
requests:
  cpu: 100m
  ephemeral-storage: 50Mi
  memory: 128Mi
{{- end -}}
{{- end -}}

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
Selector labels
*/}}
{{- define "hoppscotch.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/name: {{ include "hoppscotch.name" . }}
{{- end }}

################################################################################
# Hoppscotch default init containers partial templates
################################################################################

{{/*
Returns a default init container that waits for the database to be ready.
*/}}
{{- define "hoppscotch.defaultInitContainers.waitForDatabase" -}}
- name: wait-for-database
  image: {{ printf "%s:%s" .Values.defaultInitContainers.waitForDatabase.image.repository (default "latest" .Values.defaultInitContainers.waitForDatabase.image.tag) }}
  imagePullPolicy: {{ .Values.defaultInitContainers.waitForDatabase.image.pullPolicy }}
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
  {{- $resources := include "hoppscotch.resources" (dict "preset" .Values.defaultInitContainers.waitForDatabase.resourcesPreset "resources" .Values.defaultInitContainers.waitForDatabase.resources) }}
  {{- if $resources }}
  resources:
    {{- $resources | nindent 4 }}
  {{- end }}
  {{- if .Values.extraEnvVars }}
  env:
    {{- toYaml .Values.extraEnvVars | nindent 4 }}
  {{- end }}
  envFrom:
    - secretRef:
        name: {{ include "hoppscotch.secretName" . }}
    {{- if .Values.extraEnvVarsCM }}
    - configMapRef:
        name: {{ .Values.extraEnvVarsCM }}
    {{- end }}
    {{- if .Values.extraEnvVarsSecret }}
    - secretRef:
        name: {{ .Values.extraEnvVarsSecret }}
    {{- end }}
{{- end -}}

################################################################################
# Hoppscotch ingress partial templates
################################################################################

{{/*
Return true if cert-manager required annotations for TLS signed certificates are set in the Ingress annotations
Usage: {{ include "hoppscotch.ingress.certManagerRequest" ( dict "annotations" .Values.path.to.the.ingress.annotations ) }}
*/}}
{{- define "hoppscotch.ingress.certManagerRequest" -}}
{{ if or (hasKey .annotations "cert-manager.io/cluster-issuer") (hasKey .annotations "cert-manager.io/issuer") (hasKey .annotations "kubernetes.io/tls-acme") }}
{{- true -}}
{{- end -}}
{{- end -}}

################################################################################
# Hoppscotch PVC partial templates
################################################################################

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

################################################################################
# Hoppscotch service account partial templates
################################################################################

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
