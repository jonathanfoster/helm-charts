# Hoppscotch Helm Chart

Hoppscotch is a lightweight, web-based API development suite.

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

To install the chart with the release name `my-release`:

```bash
helm repo add jonathanfoster http://jonathanfoster.github.io/helm-charts
helm install my-release jonathanfoster/hoppscotch
```

## Parameters

<!-- markdownlint-disable MD013 MD034 -->

### Global parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imagePullSecrets | list | `[]` | This is for the secrets for pulling an image from a private repository. |

### Common parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | This is to override the chart name. |
| fullnameOverride | string | `""` | This is to override the fully qualified app name. |
| clusterDomain | string | `"cluster.local"` | Kubernetes cluster domain name |

### Hoppscotch common parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | This will set the replicaset count. |
| image.repository | string | `"hoppscotch/hoppscotch"` | This sets the image repository. |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. |
| extraEnvs | list | `[]` | This is for setting extra environment variables in the pod. |
| service.type | string | `"ClusterIP"` | This sets the service type. |
| service.port | int | `80` | This sets the ports. |
| resources | object | `{}` | Resources for the pod. This is where you can set CPU and memory limits and requests. |
| livenessProbe | object | `{}` | This is to setup the liveness and readiness probes. |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | This section is for setting up autoscaling. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| nodeSelector | object | `{}` | Node selector for pod assignment. |
| tolerations | list | `[]` | Tolerations for pod assignment. |
| affinity | object | `{}` | Affinity for pod assignment. |
| topologySpreadConstraints | list | `[]` | Topology spread constraints for pod assignment. |
| defaultInitContainers.waitForDatabase.enabled | bool | `true` | Wait for the database to be ready before starting the backend |
| defaultInitContainers.waitForDatabase.timeout | int | `60` | Time in seconds to wait for the database to be ready |
| defaultInitContainers.waitForDatabaseSetup.enabled | bool | `true` | Wait for the database setup to complete before starting the backend |
| defaultInitContainers.waitForDatabaseSetup.timeout | int | `60` | Time in seconds to wait for the setup to complete |
| setupDatabaseJob.enabled | bool | `true` | This job runs the database setup |

### Hoppscotch frontend parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| frontend.baseUrl | string | `""` | This is the URL where your deployment will be accessible from |
| frontend.shortcodeBaseUrl | string | `""` | A URL to generate shortcodes for sharing, can be the same as `frontend.baseUrl` |
| frontend.adminUrl | string | `""` | This URL is used to connect to the admin dashboard |
| frontend.backendGqlUrl | string | `""` | The URL for GraphQL within the instance |
| frontend.backendWsUrl | string | `""` | The URL for WebSockets within the instance |
| frontend.backendApiUrl | string | `""` | The URL for REST APIs within the instance |
| frontend.appTosLink | string | `""` | Optional links to the Terms & Conditions |
| frontend.appPrivacyPolicyLink | string | `""` | Optional links to the Privacy Policy |

### Hoppscotch backend parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backend.databaseUrl | string | `""` | This is where you add your Postgres database URL |
| backend.aioAlternatePort | int | `80` | This is an optional variable that lets you specify an alternate port for the AIO container’s endpoint when operating in subpath access mode |
| backend.jwtSecret | string | `"secret"` | The secret used to sign the JWT tokens |
| backend.tokenSaltComplexity | int | `10` | Defines the complexity of the SALT that is used for hashing - a higher number implies a more complex salt |
| backend.magicLinkTokenValidity | int | `3` | Duration of the validity of the magic link being sent to sign in to Hoppscotch (in days) |
| backend.refreshTokenValidity | string | `"604800000"` | Validity of the refresh token for auth (in ms) |
| backend.accessTokenValidity | string | `"86400000"` | Validity of the access token for auth (in ms) |
| backend.allowSecureCookies | bool | `true` | If disabled users will be able to use Hoppscotch over HTTP connections as well. |
| backend.dataEncryptionKey | string | `""` | A 32-character key used for encrypting sensitive data stored in the database |
| backend.redirectUrl | string | `""` | This is a fallback URL to debug when the actual redirects fail |
| backend.whitelistedOrigins | list | `[]` | URLs of Hoppscotch backend, admin dashboard, frontend app and the bundle server that are allowed to interact with the desktop app |
| backend.allowedAuthProviders | list | `["email"]` | Allows you to specify which auth providers you want to enable |
| backend.mailer.smtpEnabled | bool | `true` | Enables the SMTP mailer configuration |
| backend.mailer.useCustomConfigs | bool | `false` | When custom mailer configurations are used |
| backend.mailer.addressFrom | string | `""` | The email address that you would be using |
| backend.mailer.smtpUrl | string | `""` | The SMTP URL for email delivery |
| backend.mailer.smtpHost | string | `""` | The SMTP host |
| backend.mailer.smtpPort | int | `465` | The port to connect to the SMTP server |
| backend.mailer.smtpUser | string | `""` | The SMTP user or email for authentication |
| backend.rateLimit.ttl | int | `60` | The time it takes to refresh the maximum number of requests being received |
| backend.rateLimit.max | int | `100` | The maximum number of requests that Hoppscotch can handle under `backend.rateLimit.ttl` |

### Hoppscotch Enterprise parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enterprise.licenseKey | string | `""` | The license key required to use Hoppscotch Enterprise |
| enterprise.frontend.localProxyServerEnabled | bool | `false` | Enables a local proxy server for routing API requests. This will only work if `frontend.enableSubpathBasedAccess` is set to `true`. |
| enterprise.frontend.proxyAppUrl | string | `""` | Route all API requests via a proxy server for added security |
| enterprise.backend.githubEnterpriseAuth | object | `{"authorizationUrl":"","enabled":false,"tokenUrl":"","userEmailUrl":"","userProfileUrl":""}` | Github Enterprise authorization configuration |
| enterprise.backend.samlAuth | object | `{"audience":"","callbackUrl":"","cert":"","entryPoint":"","issuer":"","wantAssertionsSigned":true,"wantResponseSigned":false}` | SAML authorization configuration |
| enterprise.backend.oidcAuth | object | `{"authorizationUrl":"","callbackUrl":"","clientId":"","clientSecret":"","issuer":"","providerName":"","scope":[],"tokenUrl":"","userInfoUrl":""}` | OpenID Connect (OIDC) authorization configuration |
| enterprise.backend.horizontalScalingEnabled | bool | `false` | Set to true to enable horizontal scaling, which uses Redis for managing pub-sub and state across instances |
| enterprise.backend.redisUrl | string | `""` | The URL for the Redis instance used for horizontal scaling |

### Database parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| postgresql.enabled | bool | `true` | Switch to enable or disable the PostgreSQL helm chart |
| postgresql.auth.enablePostgresUser | bool | `true` | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user |
| postgresql.auth.username | string | `"hoppscotch"` | Name for a custom user to create |
| postgresql.auth.password | string | `""` | Password for the custom user to create |
| postgresql.auth.database | string | `"hoppscotch"` | Name for a custom database to create |
| postgresql.architecture | string | `"standalone"` | PostgreSQL architecture (`standalone` or `replication`) |
| postgresql.primary.resourcesPreset | string | `"nano"` | Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). |
| postgresql.primary.resources | object | `{}` | Set container requests and limits for different resources like CPU or memory (essential for production workloads) |
| externalDatabase.host | string | `"localhost"` | Database host (ignored if externalDatabase.sqlConnection is set) |
| externalDatabase.port | int | `5432` | Database port number (ignored if externalDatabase.sqlConnection is set) |
| externalDatabase.user | string | `"hoppscotch"` | Non-root username for Hoppscotch (ignored if externalDatabase.sqlConnection is set) |
| externalDatabase.database | string | `"hoppscotch"` | Hoppscotch database name (ignored if externalDatabase.sqlConnection is set) |
| externalDatabase.password | string | `""` | Password for the non-root username for Hoppscotch (ignored if externalDatabase.sqlConnection or externalDatabase.existingSecret are set) |
| externalDatabase.sqlConnection | string | `""` | SQL connection string |
| externalDatabase.existingSecret | string | `""` | Name of an existing secret resource containing the database credentials |
| externalDatabase.existingSecretPasswordKey | string | `""` | Name of an existing secret key containing the database credentials (ignored if externalDatabase.existingSecretSqlConnectionKey is set) |
| externalDatabase.existingSecretSqlConnectionKey | string | `""` | Name of an existing secret key containing the SQL connection string |

### Other Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| podSecurityContext | object | `{}` |  |
| securityContext | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.className | string | `""` |  |
| ingress.annotations | object | `{}` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| readinessProbe | object | `{}` |  |
| frontend.enableSubpathBasedAccess | bool | `true` |  |
| backend.sessionSecret | string | `""` |  |
| backend.googleAuth.clientId | string | `""` |  |
| backend.googleAuth.clientSecret | string | `""` |  |
| backend.googleAuth.callbackUrl | string | `""` |  |
| backend.googleAuth.scope | list | `[]` |  |
| backend.githubAuth.clientId | string | `""` |  |
| backend.githubAuth.clientSecret | string | `""` |  |
| backend.githubAuth.callbackUrl | string | `""` |  |
| backend.githubAuth.scope | list | `[]` |  |
| backend.microsoftAuth.clientId | string | `""` |  |
| backend.microsoftAuth.clientSecret | string | `""` |  |
| backend.microsoftAuth.callbackUrl | string | `""` |  |
| backend.microsoftAuth.scope | string | `""` |  |
| backend.microsoftAuth.tenant | string | `""` |  |
| backend.mailer.smtpSecure | bool | `true` |  |
| backend.mailer.smtpPassword | string | `""` | Provide the password set for the SMTP user |
| backend.mailer.tlsRejectUnauthorized | bool | `true` |  |
| enterprise.backend.clickhouse.allowAuditLogs | bool | `false` |  |
| enterprise.backend.clickhouse.host | string | `""` |  |
| enterprise.backend.clickhouse.user | string | `""` |  |
| enterprise.backend.clickhouse.password | string | `""` |  |
| postgresql.auth.existingSecret | string | `""` |  |
<!-- markdownlint-enable MD013 MD034 -->
