# Hoppscotch Helm Chart

![Version: 0.3.0](https://img.shields.io/badge/Version-0.3.0-informational?style=flat-square) ![AppVersion: 2025.6.0](https://img.shields.io/badge/AppVersion-2025.6.0-informational?style=flat-square)

Hoppscotch is a lightweight, web-based API development suite. It was built from the ground up with ease of use and
accessibility in mind providing all the functionality needed for developers with minimalist, unobtrusive UI.

## TL;DR

```bash
helm install my-release http://jonathanfoster.github.io/helm-charts/hoppscotch
```

## Introduction

This chart bootstraps a [Hoppscotch](https://github.com/hoppscotch/hoppscotch) deployment on a
[Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.8.0+
- Persistent volume provisioner support in the underlying infrastructure

## Installing the Chart

To install the chart with the release name `hoppscotch`:

```bash
helm repo add jonathanfoster https://jonathanfoster.github.io/helm-charts
helm install hoppscotch jonathanfoster/hoppscotch
```

## Parameters

<!-- markdownlint-disable MD013 MD034 -->

### Global Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.imageRegistry | string | `""` | Global Docker image registry |
| global.imagePullSecrets | list | `[]` | Global Docker registry secret names as an array |
| global.defaultStorageClass | string | `""` | Global default storage class for persistent volumes |
| global.security.allowInsecureImages | bool | `false` | Allows skipping image verification |

### Common Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | String to override the chart name |
| fullnameOverride | string | `""` | String to override the fully qualified name |
| namespaceOverride | string | `""` | String to override the namespace |
| commonLabels | object | `{}` | Labels to add to all deployed objects |
| commonAnnotations | object | `{}` | Annotations to add to all deployed objects |
| clusterDomain | string | `"cluster.local"` | Kubernetes cluster domain name |
| extraDeploy | list | `[]` | Array of extra objects to deploy with the release |

### Hoppscotch Common Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | Number of Hoppscotch replicas |
| image.repository | string | `"hoppscotch/hoppscotch"` | Hoppscotch image repository |
| image.pullPolicy | string | `"IfNotPresent"` | Hoppscotch image pull policy |
| image.tag | string | `""` | Hoppscotch image tag |
| containerPorts.http | int | `80` | Hoppscotch HTTP container port |
| containerPorts.https | int | `443` | Hoppscotch HTTPS container port |
| existingSecret | string | `""` | Name of existing secret containing Hoppscotch secrets |
| extraEnvVars | list | `[]` | Array of extra environment variables to be added to Hoppscotch containers |
| extraEnvVarsCM | string | `""` | Name of existing ConfigMap containing extra environment variables |
| extraEnvVarsSecret | string | `""` | Name of existing Secret containing extra environment variables |
| resourcesPreset | string | `"nano"` | Set container resources according to one common preset (allowed values: nano, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). |
| resources | object | `{}` | Set container resources for Hoppscotch (overrides resourcesPreset) |
| livenessProbe | object | `{}` | Configure Hoppscotch liveness probe |
| readinessProbe | object | `{"httpGet":{"path":"/backend/ping","port":80}}` | Configure Hoppscotch readiness probe |
| podAnnotations | object | `{}` | Annotations to add to Hoppscotch pods |
| podLabels | object | `{}` | Labels to add to Hoppscotch pods |
| podSecurityContext | object | `{}` | Security context for Hoppscotch pods |
| securityContext | object | `{}` | Security context for Hoppscotch containers |
| updateStrategy.type | string | `"RollingUpdate"` | Deployment update strategy type (RollingUpdate or Recreate) |
| updateStrategy.rollingUpdate | object | `{"maxSurge":1,"maxUnavailable":1}` | Rolling update configuration parameters |
| updateStrategy.rollingUpdate.maxUnavailable | int | `1` | Maximum number of pods that can be unavailable during the update |
| updateStrategy.rollingUpdate.maxSurge | int | `1` | Maximum number of pods that can be created above the desired number of pods |
| autoscaling.enabled | bool | `false` | Enable autoscaling for Hoppscotch deployment |
| autoscaling.minReplicas | int | `1` | Minimum number of Hoppscotch replicas |
| autoscaling.maxReplicas | int | `100` | Maximum number of Hoppscotch replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target CPU utilization percentage for autoscaling |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` | Target memory utilization percentage for autoscaling |
| nodeSelector | object | `{}` | Node labels for Hoppscotch pods assignment |
| tolerations | list | `[]` | Tolerations for Hoppscotch pods assignment |
| affinity | object | `{}` | Affinity for Hoppscotch pods assignment |
| topologySpreadConstraints | list | `[]` | Topology spread constraints for Hoppscotch pods assignment |
| volumes | list | `[]` | Extra volumes to add to Hoppscotch deployment |
| volumeMounts | list | `[]` | Extra volume mounts to add to Hoppscotch containers |
| setupDatabaseJob.enabled | bool | `true` | Enable database setup job |

### Hoppscotch Application Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| hoppscotch.frontend.baseUrl | string | `""` | Base URL where the Hoppscotch frontend will be accessible from |
| hoppscotch.frontend.shortcodeBaseUrl | string | `""` | URL used to generate shortcodes for sharing, can be the same as baseUrl |
| hoppscotch.frontend.adminUrl | string | `""` | URL where the Hoppscotch admin dashboard will be accessible from |
| hoppscotch.frontend.backendGqlUrl | string | `""` | URL for GraphQL endpoint within the Hoppscotch instance |
| hoppscotch.frontend.backendWsUrl | string | `""` | URL for WebSocket endpoint within the Hoppscotch instance |
| hoppscotch.frontend.backendApiUrl | string | `""` | URL for REST API endpoint within the Hoppscotch instance |
| hoppscotch.frontend.appTosLink | string | `""` | Link to Terms of Service page (optional) |
| hoppscotch.frontend.appPrivacyPolicyLink | string | `""` | Link to Privacy Policy page (optional) |
| hoppscotch.frontend.enableSubpathBasedAccess | bool | `true` | Enable subpath based access (required for desktop app support) |
| hoppscotch.frontend.localProxyServerEnabled | bool | `false` | Enable local proxy server for routing API requests (requires subpath access). Enterprise Edition required. |
| hoppscotch.frontend.proxyAppUrl | string | `""` | URL of proxy server for routing API requests (optional). Enterprise Edition required. |
| hoppscotch.backend.aioAlternatePort | int | `80` | Alternate port for AIO container endpoint when using subpath access mode |
| hoppscotch.backend.authToken.jwtSecret | string | `""` | Secret key for JWT token generation and validation (auto-generated if empty) |
| hoppscotch.backend.authToken.tokenSaltComplexity | int | `10` | Complexity of the SALT used for hashing (higher = more secure) |
| hoppscotch.backend.authToken.magicLinkTokenValidity | int | `3` | Duration of magic link token validity for sign-in (in days) |
| hoppscotch.backend.authToken.refreshTokenValidity | string | `"604800000"` | Validity of refresh token for authentication (in milliseconds) |
| hoppscotch.backend.authToken.accessTokenValidity | string | `"86400000"` | Validity of access token for authentication (in milliseconds) |
| hoppscotch.backend.authToken.sessionSecret | string | `""` | Secret key for session management (auto-generated if empty) |
| hoppscotch.backend.allowSecureCookies | bool | `true` | Allow secure cookies (recommended for HTTPS deployments) |
| hoppscotch.backend.dataEncryptionKey | string | `""` | 32-character key for encrypting sensitive data stored in database (auto-generated if empty) |
| hoppscotch.backend.redirectUrl | string | `""` | Fallback URL for debugging when redirects fail |
| hoppscotch.backend.whitelistedOrigins | list | `[]` | List of origins allowed to interact with the app through cross-origin requests |
| hoppscotch.backend.auth.allowedProviders | list | `["email"]` | List of allowed authentication providers (email, google, github, microsoft, oidc, saml) |
| hoppscotch.backend.auth.google.clientId | string | `""` | Google OAuth client ID |
| hoppscotch.backend.auth.google.clientSecret | string | `""` | Google OAuth client secret |
| hoppscotch.backend.auth.google.callbackUrl | string | `""` | Google OAuth callback URL |
| hoppscotch.backend.auth.google.scope | list | `["email","profile"]` | Google OAuth scopes to request |
| hoppscotch.backend.auth.github.clientId | string | `""` | GitHub OAuth client ID |
| hoppscotch.backend.auth.github.clientSecret | string | `""` | GitHub OAuth client secret |
| hoppscotch.backend.auth.github.callbackUrl | string | `""` | GitHub OAuth callback URL |
| hoppscotch.backend.auth.github.scope | list | `["user:email"]` | GitHub OAuth scopes to request |
| hoppscotch.backend.auth.githubEnterprise.enabled | bool | `false` | Enable GitHub Enterprise authentication. Enterprise Edition required. |
| hoppscotch.backend.auth.githubEnterprise.authorizationUrl | string | `""` | GitHub Enterprise authorization URL |
| hoppscotch.backend.auth.githubEnterprise.tokenUrl | string | `""` | GitHub Enterprise token URL |
| hoppscotch.backend.auth.githubEnterprise.userProfileUrl | string | `""` | GitHub Enterprise user profile URL |
| hoppscotch.backend.auth.githubEnterprise.userEmailUrl | string | `""` | GitHub Enterprise user email URL |
| hoppscotch.backend.auth.microsoft.clientId | string | `""` | Microsoft OAuth client ID |
| hoppscotch.backend.auth.microsoft.clientSecret | string | `""` | Microsoft OAuth client secret |
| hoppscotch.backend.auth.microsoft.callbackUrl | string | `""` | Microsoft OAuth callback URL |
| hoppscotch.backend.auth.microsoft.scope | string | `"user.read"` | Microsoft OAuth scopes to request |
| hoppscotch.backend.auth.microsoft.tenant | string | `""` | Microsoft OAuth tenant ID (common for multi-tenant apps) |
| hoppscotch.backend.auth.oidc.providerName | string | `""` | OIDC provider display name |
| hoppscotch.backend.auth.oidc.issuer | string | `""` | OIDC issuer URL |
| hoppscotch.backend.auth.oidc.authorizationUrl | string | `""` | OIDC authorization URL |
| hoppscotch.backend.auth.oidc.tokenUrl | string | `""` | OIDC token URL |
| hoppscotch.backend.auth.oidc.userInfoUrl | string | `""` | OIDC user info URL |
| hoppscotch.backend.auth.oidc.clientId | string | `""` | OIDC client ID |
| hoppscotch.backend.auth.oidc.clientSecret | string | `""` | OIDC client secret |
| hoppscotch.backend.auth.oidc.callbackUrl | string | `""` | OIDC callback URL |
| hoppscotch.backend.auth.oidc.scope | list | `["openid","profile","email"]` | OIDC scopes to request |
| hoppscotch.backend.auth.saml.issuer | string | `""` | SAML issuer identifier. Enterprise Edition required. |
| hoppscotch.backend.auth.saml.audience | string | `""` | SAML audience identifier |
| hoppscotch.backend.auth.saml.callbackUrl | string | `""` | SAML callback URL |
| hoppscotch.backend.auth.saml.cert | string | `""` | SAML certificate for signature verification |
| hoppscotch.backend.auth.saml.entryPoint | string | `""` | SAML identity provider entry point URL |
| hoppscotch.backend.auth.saml.wantAssertionsSigned | bool | `true` | Require signed SAML assertions |
| hoppscotch.backend.auth.saml.wantResponseSigned | bool | `false` | Require signed SAML responses |
| hoppscotch.backend.mailer.smtpEnabled | bool | `true` | Enable SMTP mailer for email delivery |
| hoppscotch.backend.mailer.useCustomConfigs | bool | `false` | Use custom SMTP configuration instead of SMTP URL |
| hoppscotch.backend.mailer.addressFrom | string | `"no-reply@example.com"` | Email address to use as sender |
| hoppscotch.backend.mailer.smtpUrl | string | `"smtps://user:pass@smtp.example.com"` | SMTP URL for email delivery (used when useCustomConfigs is false) |
| hoppscotch.backend.mailer.smtpHost | string | `""` | SMTP host (used when useCustomConfigs is true) |
| hoppscotch.backend.mailer.smtpPort | int | `465` | SMTP port (used when useCustomConfigs is true) |
| hoppscotch.backend.mailer.smtpSecure | bool | `true` | Use secure connection for SMTP (used when useCustomConfigs is true) |
| hoppscotch.backend.mailer.smtpUser | string | `""` | SMTP username (used when useCustomConfigs is true) |
| hoppscotch.backend.mailer.smtpPassword | string | `""` | SMTP password (used when useCustomConfigs is true) |
| hoppscotch.backend.mailer.tlsRejectUnauthorized | bool | `true` | Reject unauthorized TLS connections |
| hoppscotch.backend.rateLimit.ttl | int | `60` | Time window for rate limiting (in seconds) |
| hoppscotch.backend.rateLimit.max | int | `100` | Maximum number of requests per IP within TTL window |
| hoppscotch.backend.enterpriseLicenseKey | string | `""` | Enterprise license key for Hoppscotch Enterprise features |
| hoppscotch.backend.clickhouse.allowAuditLogs | bool | `false` | Enable audit logs collection to ClickHouse. Enterprise Edition required. |
| hoppscotch.backend.horizontalScalingEnabled | bool | `false` | Enable horizontal scaling with Redis for state management. Enterprise Edition required. |

### Traffic Exposure Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| service.ports.http | int | `80` | Service HTTP port |
| service.ports.https | int | `443` | Service HTTPS port |
| service.clusterIP | string | `""` | Static cluster IP address (optional) |
| service.nodePorts.http | string | `""` | NodePort for HTTP (when service type is NodePort) |
| service.nodePorts.https | string | `""` | NodePort for HTTPS (when service type is NodePort) |
| service.loadBalancerIP | string | `""` | Load balancer IP address (when service type is LoadBalancer) |
| service.loadBalancerSourceRanges | list | `[]` | Load balancer source IP ranges (when service type is LoadBalancer) |
| service.externalTrafficPolicy | string | `"Cluster"` | External traffic policy (Cluster or Local) |
| service.annotations | object | `{}` | Service annotations |
| service.sessionAffinity | string | `"None"` | Session affinity (None or ClientIP) |
| service.sessionAffinityConfig | object | `{}` | Session affinity configuration |
| service.extraPorts | list | `[]` | Extra service ports |
| networkPolicy.enabled | bool | `false` | Enable NetworkPolicy for Hoppscotch pods |
| networkPolicy.allowExternal | bool | `true` | Allow external traffic to Hoppscotch pods |
| networkPolicy.allowExternalEgress | bool | `true` | Allow external egress traffic from Hoppscotch pods |
| networkPolicy.addExternalClientAccess | bool | `true` | Add external client access to NetworkPolicy |
| networkPolicy.extraIngress | list | `[]` | Extra ingress rules for NetworkPolicy |
| networkPolicy.extraEgress | list | `[]` | Extra egress rules for NetworkPolicy |
| networkPolicy.ingressPodMatchLabels | object | `{}` | Pod selector labels for ingress rules |
| networkPolicy.ingressNSMatchLabels | object | `{}` | Namespace selector labels for ingress rules |
| networkPolicy.ingressNSPodMatchLabels | object | `{}` | Namespace pod selector labels for ingress rules |
| ingress.enabled | bool | `false` | Enable ingress for Hoppscotch |
| ingress.ingressClassName | string | `""` | Ingress class name |
| ingress.hostname | string | `"hoppscotch.local"` | Ingress hostname |
| ingress.path | string | `"/"` | Ingress path |
| ingress.pathType | string | `"ImplementationSpecific"` | Ingress path type |
| ingress.apiVersion | string | `""` | Ingress API version |
| ingress.annotations | object | `{}` | Ingress annotations |
| ingress.tls | bool | `false` | Enable TLS for ingress |
| ingress.selfSigned | bool | `false` | Create self-signed TLS certificates |
| ingress.extraHosts | list | `[]` | Extra hostnames for ingress |
| ingress.extraPaths | list | `[]` | Extra paths for ingress |
| ingress.extraTls | list | `[]` | Extra TLS configurations for ingress |
| ingress.secrets | list | `[]` | TLS secrets for ingress |
| ingress.extraRules | list | `[]` | Extra ingress rules |

### Persistence Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.enabled | bool | `false` | Enable persistent storage for Hoppscotch |
| persistence.storageClass | string | `""` | Storage class for persistent volume |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access modes for persistent volume |
| persistence.size | string | `"8Gi"` | Size of persistent volume |
| persistence.mountPath | string | `"/hoppscotch/data"` | Mount path for persistent volume |
| persistence.subPath | string | `""` | Subpath within persistent volume |
| persistence.annotations | object | `{}` | Annotations for persistent volume claim |
| persistence.dataSource | object | `{}` | Data source for persistent volume |
| persistence.existingClaim | string | `""` | Use existing persistent volume claim |
| persistence.selector | object | `{}` | Selector for persistent volume |

### Default Init Containers Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| defaultInitContainers.waitForDatabase.enabled | bool | `true` | Enable init container that waits for database to be ready |
| defaultInitContainers.waitForDatabase.image.repository | string | `"postgres"` | Image repository for database wait init container |
| defaultInitContainers.waitForDatabase.image.tag | string | `"16-alpine"` | Image tag for database wait init container |
| defaultInitContainers.waitForDatabase.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for database wait init container |
| defaultInitContainers.waitForDatabase.timeout | int | `300` | Timeout for database wait init container (in seconds) |
| defaultInitContainers.waitForDatabase.resourcesPreset | string | `"nano"` | Resource preset for database wait init container |
| defaultInitContainers.waitForDatabase.resources | object | `{}` | Resource limits/requests for database wait init container |
| defaultInitContainers.waitForDatabaseSetup.enabled | bool | `true` | Enable init container that waits for database setup job to complete |
| defaultInitContainers.waitForDatabaseSetup.timeout | int | `300` | Timeout for database setup wait init container (in seconds) |
| defaultInitContainers.waitForDatabaseSetup.resourcesPreset | string | `"nano"` | Resource preset for database setup wait init container |
| defaultInitContainers.waitForDatabaseSetup.resources | object | `{}` | Resource limits/requests for database setup wait init container |

### Other Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| serviceAccount.create | bool | `false` | Create service account for Hoppscotch |
| serviceAccount.name | string | `""` | Service account name (auto-generated if not specified) |
| serviceAccount.annotations | object | `{}` | Service account annotations |
| serviceAccount.automountServiceAccountToken | bool | `true` | Auto-mount service account token |
| rbac.create | bool | `false` | Create RBAC resources for Hoppscotch |
| rbac.rules | list | `[]` | RBAC rules for Hoppscotch |
| metrics.enabled | bool | `false` | Enable metrics collection for Hoppscotch |
| metrics.serviceMonitor.enabled | bool | `false` | Enable ServiceMonitor for Prometheus monitoring |
| metrics.serviceMonitor.namespace | string | `""` | Namespace for ServiceMonitor (defaults to release namespace) |
| metrics.serviceMonitor.annotations | object | `{}` | ServiceMonitor annotations |
| metrics.serviceMonitor.labels | object | `{}` | ServiceMonitor labels |
| metrics.serviceMonitor.jobLabel | string | `""` | ServiceMonitor job label |
| metrics.serviceMonitor.honorLabels | bool | `false` | Honor labels from target |
| metrics.serviceMonitor.interval | string | `""` | ServiceMonitor scrape interval |
| metrics.serviceMonitor.scrapeTimeout | string | `""` | ServiceMonitor scrape timeout |
| metrics.serviceMonitor.tlsConfig | object | `{}` | ServiceMonitor TLS configuration |
| metrics.serviceMonitor.metricsRelabelings | list | `[]` | ServiceMonitor metrics relabelings |
| metrics.serviceMonitor.relabelings | list | `[]` | ServiceMonitor relabelings |
| metrics.serviceMonitor.selector | object | `{}` | ServiceMonitor selector |

### Database Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| postgresql.enabled | bool | `true` | Enable PostgreSQL subchart |
| postgresql.auth.enablePostgresUser | bool | `true` | Enable PostgreSQL default postgres user |
| postgresql.auth.username | string | `""` | PostgreSQL application username |
| postgresql.auth.password | string | `""` | PostgreSQL application password |
| postgresql.auth.database | string | `""` | PostgreSQL application database name |
| postgresql.auth.existingSecret | string | `""` | Existing secret containing PostgreSQL credentials |
| postgresql.architecture | string | `"standalone"` | PostgreSQL architecture (standalone or replication) |
| postgresql.primary.resourcesPreset | string | `"nano"` | PostgreSQL primary resource preset |
| postgresql.primary.resources | object | `{}` | PostgreSQL primary resource limits/requests |
| externalDatabase.host | string | `""` | External PostgreSQL host |
| externalDatabase.port | int | `5432` | External PostgreSQL port |
| externalDatabase.user | string | `""` | External PostgreSQL username |
| externalDatabase.database | string | `""` | External PostgreSQL database name |
| externalDatabase.password | string | `""` | External PostgreSQL password |
| externalDatabase.sqlConnection | string | `""` | External PostgreSQL full connection string (overrides other settings) |
| externalDatabase.existingSecret | string | `""` | Existing secret containing external PostgreSQL credentials |
| externalDatabase.existingSecretPasswordKey | string | `""` | Key in existing secret containing password |
| externalDatabase.existingSecretSqlConnectionKey | string | `""` | Key in existing secret containing SQL connection string |

### Redis Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| redis.enabled | bool | `false` | Enable Redis subchart |
| redis.auth.enabled | bool | `true` | Enable Redis authentication |
| redis.auth.password | string | `""` | Redis password |
| redis.auth.existingSecret | string | `""` | Existing secret containing Redis credentials |
| redis.architecture | string | `"standalone"` | Redis architecture (standalone or replication) |
| redis.master.resourcesPreset | string | `"nano"` | Redis master resource preset |
| redis.master.resources | object | `{}` | Redis master resource limits/requests |
| externalRedis.host | string | `""` | External Redis host |
| externalRedis.port | int | `6379` | External Redis port |
| externalRedis.password | string | `""` | External Redis password |
| externalRedis.existingSecret | string | `""` | Existing secret containing external Redis credentials |
| externalRedis.existingSecretPasswordKey | string | `""` | Key in existing secret containing password |

### ClickHouse Parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| clickhouse.enabled | bool | `false` | Enable ClickHouse subchart |
| clickhouse.auth.username | string | `""` | ClickHouse username |
| clickhouse.auth.password | string | `""` | ClickHouse password |
| clickhouse.auth.existingSecret | string | `""` | Existing secret containing ClickHouse credentials |
| clickhouse.resourcesPreset | string | `"nano"` | ClickHouse resource preset |
| clickhouse.resources | object | `{}` | ClickHouse resource limits/requests |
| externalClickhouse.host | string | `""` | External ClickHouse host |
| externalClickhouse.port | int | `8123` | External ClickHouse port |
| externalClickhouse.user | string | `""` | External ClickHouse username |
| externalClickhouse.password | string | `""` | External ClickHouse password |
| externalClickhouse.existingSecret | string | `""` | Existing secret containing external ClickHouse credentials |
| externalClickhouse.existingSecretPasswordKey | string | `""` | Key in existing secret containing password |
<!-- markdownlint-enable MD013 MD034 -->
