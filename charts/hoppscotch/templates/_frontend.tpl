################################################################################
# Hoppscotch frontend partial templates
################################################################################

{{/*
Generate the admin URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.adminUrl" -}}
{{- if .Values.hoppscotch.frontend.adminUrl -}}
{{- .Values.hoppscotch.frontend.adminUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- if .Values.hoppscotch.frontend.enableSubpathBasedAccess -}}
{{- printf "%s://%s/admin" $scheme .Values.ingress.hostname -}}
{{- else -}}
{{- printf "%s://%s/admin" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate the base URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.baseUrl" -}}
{{- if .Values.hoppscotch.frontend.baseUrl -}}
{{- .Values.hoppscotch.frontend.baseUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end }}

{{/*
Generate the backend API URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.backendApiUrl" -}}
{{- if .Values.hoppscotch.frontend.backendApiUrl -}}
{{- .Values.hoppscotch.frontend.backendApiUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- if .Values.hoppscotch.frontend.enableSubpathBasedAccess -}}
{{- printf "%s://%s/backend/v1" $scheme .Values.ingress.hostname -}}
{{- else -}}
{{- printf "%s://%s/backend/v1" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate the backend GraphQL URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.backendGqlUrl" -}}
{{- if .Values.hoppscotch.frontend.backendGqlUrl -}}
{{- .Values.hoppscotch.frontend.backendGqlUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- if .Values.hoppscotch.frontend.enableSubpathBasedAccess -}}
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
{{- if .Values.hoppscotch.frontend.backendWsUrl -}}
{{- .Values.hoppscotch.frontend.backendWsUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "ws" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "wss" -}}
{{- end -}}
{{- if .Values.hoppscotch.frontend.enableSubpathBasedAccess -}}
{{- printf "%s://%s/backend/graphql" $scheme .Values.ingress.hostname -}}
{{- else -}}
{{- printf "%s://%s/backend/graphql" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate the shortcode base URL for the frontend based on ingress configuration
*/}}
{{- define "hoppscotch.frontend.shortcodeBaseUrl" -}}
{{- if .Values.hoppscotch.frontend.shortcodeBaseUrl -}}
{{- .Values.hoppscotch.frontend.shortcodeBaseUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- end -}}
{{- end }}
