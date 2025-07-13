{{/*
Returns an init container that waits for the database to be ready.
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

{{/*
Returns an init container that waits for the database to be setup.
*/}}
{{- define "hoppscotch.defaultInitContainers.waitForDatabaseSetup" -}}
- name: wait-for-database-setup
  image: {{ include "hoppscotch.image" . }}
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  command:
    - /bin/sh
  args:
    - -c
    - |
      end_time=$(($(date +%s) + $0))
      until ./node_modules/.bin/prisma migrate status; do
        if [ $(date +%s) -ge $end_time ]; then
          exit 1
        fi
        sleep 2
      done
    - {{ .Values.defaultInitContainers.waitForDatabaseSetup.timeout | default 60 | quote }}
  {{- $resources := include "hoppscotch.resources" (dict "preset" .Values.defaultInitContainers.waitForDatabaseSetup.resourcesPreset "resources" .Values.defaultInitContainers.waitForDatabaseSetup.resources) }}
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
