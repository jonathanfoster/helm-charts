################################################################################
# Hoppscotch backend partial templates
################################################################################

{{/*
Generate GitHub auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.github.callbackUrl" -}}
{{- if .Values.hoppscotch.backend.auth.github.callbackUrl -}}
{{- .Values.hoppscotch.backend.auth.github.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.hoppscotch.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/github/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/github/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate Google auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.google.callbackUrl" -}}
{{- if .Values.hoppscotch.backend.auth.google.callbackUrl -}}
{{- .Values.hoppscotch.backend.auth.google.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.hoppscotch.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/google/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/google/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate Microsoft auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.microsoft.callbackUrl" -}}
{{- if .Values.hoppscotch.backend.auth.microsoft.callbackUrl -}}
{{- .Values.hoppscotch.backend.auth.microsoft.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.hoppscotch.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/microsoft/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/microsoft/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate OIDC auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.oidc.callbackUrl" -}}
{{- if .Values.hoppscotch.backend.auth.oidc.callbackUrl -}}
{{- .Values.hoppscotch.backend.auth.oidc.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.hoppscotch.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/oidc/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/oidc/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate SAML auth callback URL based on ingress configuration
*/}}
{{- define "hoppscotch.backend.auth.saml.callbackUrl" -}}
{{- if .Values.hoppscotch.backend.auth.saml.callbackUrl -}}
{{- .Values.hoppscotch.backend.auth.saml.callbackUrl -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- if .Values.hoppscotch.frontend.enableSubpathBasedAccess -}}
{{- printf "%s/backend/v1/auth/saml/callback" $baseUrl -}}
{{- else -}}
{{- printf "%s/v1/auth/saml/callback" $baseUrl -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Generate the redirect URL for the backend based on ingress configuration
*/}}
{{- define "hoppscotch.backend.redirectUrl" -}}
{{- if .Values.hoppscotch.backend.redirectUrl -}}
{{- .Values.hoppscotch.backend.redirectUrl -}}
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
{{- if .Values.hoppscotch.backend.whitelistedOrigins -}}
{{- .Values.hoppscotch.backend.whitelistedOrigins | join "," -}}
{{- else if .Values.ingress.enabled -}}
{{- $scheme := "http" -}}
{{- if .Values.ingress.tls -}}
{{- $scheme = "https" -}}
{{- end -}}
{{- $baseUrl := printf "%s://%s" $scheme .Values.ingress.hostname -}}
{{- printf "%s,%s/admin,%s/backend,app://hoppscotch" $baseUrl $baseUrl $baseUrl -}}
{{- end -}}
{{- end }}
