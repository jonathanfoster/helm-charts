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
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.imageRegistry | string | `""` |  |
| global.imagePullSecrets | list | `[]` |  |
| global.defaultStorageClass | string | `""` |  |
| global.security.allowInsecureImages | bool | `false` |  |
| nameOverride | string | `""` |  |
| fullnameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| commonLabels | object | `{}` |  |
| commonAnnotations | object | `{}` |  |
| clusterDomain | string | `"cluster.local"` |  |
| extraDeploy | list | `[]` |  |
| replicaCount | int | `1` |  |
| image.repository | string | `"hoppscotch/hoppscotch"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| containerPorts.http | int | `80` |  |
| containerPorts.https | int | `443` |  |
| existingSecret | string | `""` |  |
| extraEnvVars | list | `[]` |  |
| extraEnvVarsCM | string | `""` |  |
| extraEnvVarsSecret | string | `""` |  |
| resourcesPreset | string | `"nano"` |  |
| resources | object | `{}` |  |
| livenessProbe | object | `{}` |  |
| readinessProbe | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| securityContext | object | `{}` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |
| updateStrategy.rollingUpdate | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| topologySpreadConstraints | list | `[]` |  |
| volumes | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| setupDatabaseJob.enabled | bool | `true` |  |
| hoppscotch.frontend.baseUrl | string | `""` |  |
| hoppscotch.frontend.shortcodeBaseUrl | string | `""` |  |
| hoppscotch.frontend.adminUrl | string | `""` |  |
| hoppscotch.frontend.backendGqlUrl | string | `""` |  |
| hoppscotch.frontend.backendWsUrl | string | `""` |  |
| hoppscotch.frontend.backendApiUrl | string | `""` |  |
| hoppscotch.frontend.appTosLink | string | `""` |  |
| hoppscotch.frontend.appPrivacyPolicyLink | string | `""` |  |
| hoppscotch.frontend.enableSubpathBasedAccess | bool | `true` |  |
| hoppscotch.frontend.localProxyServerEnabled | bool | `false` |  |
| hoppscotch.frontend.proxyAppUrl | string | `""` |  |
| hoppscotch.backend.databaseUrl | string | `""` |  |
| hoppscotch.backend.aioAlternatePort | int | `80` |  |
| hoppscotch.backend.authToken.jwtSecret | string | `"secret"` |  |
| hoppscotch.backend.authToken.tokenSaltComplexity | int | `10` |  |
| hoppscotch.backend.authToken.magicLinkTokenValidity | int | `3` |  |
| hoppscotch.backend.authToken.refreshTokenValidity | string | `"604800000"` |  |
| hoppscotch.backend.authToken.accessTokenValidity | string | `"86400000"` |  |
| hoppscotch.backend.authToken.sessionSecret | string | `"secret"` |  |
| hoppscotch.backend.allowSecureCookies | bool | `true` |  |
| hoppscotch.backend.dataEncryptionKey | string | `"12345678901234567890123456789012"` |  |
| hoppscotch.backend.redirectUrl | string | `""` |  |
| hoppscotch.backend.whitelistedOrigins | list | `[]` |  |
| hoppscotch.backend.auth.allowedProviders[0] | string | `"email"` |  |
| hoppscotch.backend.auth.google.clientId | string | `""` |  |
| hoppscotch.backend.auth.google.clientSecret | string | `""` |  |
| hoppscotch.backend.auth.google.callbackUrl | string | `""` |  |
| hoppscotch.backend.auth.google.scope[0] | string | `"email"` |  |
| hoppscotch.backend.auth.google.scope[1] | string | `"profile"` |  |
| hoppscotch.backend.auth.github.clientId | string | `""` |  |
| hoppscotch.backend.auth.github.clientSecret | string | `""` |  |
| hoppscotch.backend.auth.github.callbackUrl | string | `""` |  |
| hoppscotch.backend.auth.github.scope[0] | string | `"user:email"` |  |
| hoppscotch.backend.auth.githubEnterprise.enabled | bool | `false` |  |
| hoppscotch.backend.auth.githubEnterprise.authorizationUrl | string | `""` |  |
| hoppscotch.backend.auth.githubEnterprise.tokenUrl | string | `""` |  |
| hoppscotch.backend.auth.githubEnterprise.userProfileUrl | string | `""` |  |
| hoppscotch.backend.auth.githubEnterprise.userEmailUrl | string | `""` |  |
| hoppscotch.backend.auth.microsoft.clientId | string | `""` |  |
| hoppscotch.backend.auth.microsoft.clientSecret | string | `""` |  |
| hoppscotch.backend.auth.microsoft.callbackUrl | string | `""` |  |
| hoppscotch.backend.auth.microsoft.scope | string | `"user.read"` |  |
| hoppscotch.backend.auth.microsoft.tenant | string | `""` |  |
| hoppscotch.backend.auth.oidc.providerName | string | `""` |  |
| hoppscotch.backend.auth.oidc.issuer | string | `""` |  |
| hoppscotch.backend.auth.oidc.authorizationUrl | string | `""` |  |
| hoppscotch.backend.auth.oidc.tokenUrl | string | `""` |  |
| hoppscotch.backend.auth.oidc.userInfoUrl | string | `""` |  |
| hoppscotch.backend.auth.oidc.clientId | string | `""` |  |
| hoppscotch.backend.auth.oidc.clientSecret | string | `""` |  |
| hoppscotch.backend.auth.oidc.callbackUrl | string | `""` |  |
| hoppscotch.backend.auth.oidc.scope[0] | string | `"openid"` |  |
| hoppscotch.backend.auth.oidc.scope[1] | string | `"profile"` |  |
| hoppscotch.backend.auth.oidc.scope[2] | string | `"email"` |  |
| hoppscotch.backend.auth.saml.issuer | string | `""` |  |
| hoppscotch.backend.auth.saml.audience | string | `""` |  |
| hoppscotch.backend.auth.saml.callbackUrl | string | `""` |  |
| hoppscotch.backend.auth.saml.cert | string | `""` |  |
| hoppscotch.backend.auth.saml.entryPoint | string | `""` |  |
| hoppscotch.backend.auth.saml.wantAssertionsSigned | bool | `true` |  |
| hoppscotch.backend.auth.saml.wantResponseSigned | bool | `false` |  |
| hoppscotch.backend.mailer.smtpEnabled | bool | `true` |  |
| hoppscotch.backend.mailer.useCustomConfigs | bool | `false` |  |
| hoppscotch.backend.mailer.addressFrom | string | `"no-reply@example.com"` |  |
| hoppscotch.backend.mailer.smtpUrl | string | `"smtps://user:pass@smtp.example.com"` |  |
| hoppscotch.backend.mailer.smtpHost | string | `""` |  |
| hoppscotch.backend.mailer.smtpPort | int | `465` |  |
| hoppscotch.backend.mailer.smtpSecure | bool | `true` |  |
| hoppscotch.backend.mailer.smtpUser | string | `""` |  |
| hoppscotch.backend.mailer.smtpPassword | string | `""` |  |
| hoppscotch.backend.mailer.tlsRejectUnauthorized | bool | `true` |  |
| hoppscotch.backend.rateLimit.ttl | int | `60` |  |
| hoppscotch.backend.rateLimit.max | int | `100` |  |
| hoppscotch.backend.enterpriseLicenseKey | string | `""` |  |
| hoppscotch.backend.clickhouse.allowAuditLogs | bool | `false` |  |
| hoppscotch.backend.clickhouse.host | string | `""` |  |
| hoppscotch.backend.clickhouse.user | string | `""` |  |
| hoppscotch.backend.clickhouse.password | string | `""` |  |
| hoppscotch.backend.horizontalScalingEnabled | bool | `false` |  |
| hoppscotch.backend.redisUrl | string | `""` |  |
| service.type | string | `"ClusterIP"` |  |
| service.ports.http | int | `80` |  |
| service.ports.https | int | `443` |  |
| service.clusterIP | string | `""` |  |
| service.nodePorts.http | string | `""` |  |
| service.nodePorts.https | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.externalTrafficPolicy | string | `"Cluster"` |  |
| service.annotations | object | `{}` |  |
| service.sessionAffinity | string | `"None"` |  |
| service.sessionAffinityConfig | object | `{}` |  |
| service.extraPorts | list | `[]` |  |
| networkPolicy.enabled | bool | `false` |  |
| networkPolicy.allowExternal | bool | `true` |  |
| networkPolicy.allowExternalEgress | bool | `true` |  |
| networkPolicy.addExternalClientAccess | bool | `true` |  |
| networkPolicy.extraIngress | list | `[]` |  |
| networkPolicy.extraEgress | list | `[]` |  |
| networkPolicy.ingressPodMatchLabels | object | `{}` |  |
| networkPolicy.ingressNSMatchLabels | object | `{}` |  |
| networkPolicy.ingressNSPodMatchLabels | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.hostname | string | `"hoppscotch.local"` |  |
| ingress.path | string | `"/"` |  |
| ingress.pathType | string | `"ImplementationSpecific"` |  |
| ingress.apiVersion | string | `""` |  |
| ingress.annotations | object | `{}` |  |
| ingress.tls | bool | `false` |  |
| ingress.selfSigned | bool | `false` |  |
| ingress.extraHosts | list | `[]` |  |
| ingress.extraPaths | list | `[]` |  |
| ingress.extraTls | list | `[]` |  |
| ingress.secrets | list | `[]` |  |
| ingress.extraRules | list | `[]` |  |
| persistence.enabled | bool | `false` |  |
| persistence.storageClass | string | `""` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.size | string | `"8Gi"` |  |
| persistence.mountPath | string | `"/hoppscotch/data"` |  |
| persistence.subPath | string | `""` |  |
| persistence.annotations | object | `{}` |  |
| persistence.dataSource | object | `{}` |  |
| persistence.existingClaim | string | `""` |  |
| persistence.selector | object | `{}` |  |
| defaultInitContainers.waitForDatabase.enabled | bool | `true` |  |
| defaultInitContainers.waitForDatabase.timeout | int | `300` |  |
| defaultInitContainers.waitForDatabase.resourcesPreset | string | `"nano"` |  |
| defaultInitContainers.waitForDatabase.resources | object | `{}` |  |
| defaultInitContainers.waitForDatabaseSetup.enabled | bool | `true` |  |
| defaultInitContainers.waitForDatabaseSetup.timeout | int | `300` |  |
| defaultInitContainers.waitForDatabaseSetup.resourcesPreset | string | `"nano"` |  |
| defaultInitContainers.waitForDatabaseSetup.resources | object | `{}` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| rbac.create | bool | `false` |  |
| rbac.rules | list | `[]` |  |
| metrics.enabled | bool | `false` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.annotations | object | `{}` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.jobLabel | string | `""` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.interval | string | `""` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
| metrics.serviceMonitor.tlsConfig | object | `{}` |  |
| metrics.serviceMonitor.metricsRelabelings | list | `[]` |  |
| metrics.serviceMonitor.relabelings | list | `[]` |  |
| metrics.serviceMonitor.selector | object | `{}` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.auth.enablePostgresUser | bool | `true` |  |
| postgresql.auth.username | string | `"hoppscotch"` |  |
| postgresql.auth.password | string | `"secret"` |  |
| postgresql.auth.database | string | `"hoppscotch"` |  |
| postgresql.auth.existingSecret | string | `""` |  |
| postgresql.architecture | string | `"standalone"` |  |
| postgresql.primary.resourcesPreset | string | `"nano"` |  |
| postgresql.primary.resources | object | `{}` |  |
| externalDatabase.host | string | `"localhost"` |  |
| externalDatabase.port | int | `5432` |  |
| externalDatabase.user | string | `"hoppscotch"` |  |
| externalDatabase.database | string | `"hoppscotch"` |  |
| externalDatabase.password | string | `""` |  |
| externalDatabase.sqlConnection | string | `""` |  |
| externalDatabase.existingSecret | string | `""` |  |
| externalDatabase.existingSecretPasswordKey | string | `""` |  |
| externalDatabase.existingSecretSqlConnectionKey | string | `""` |  |
| redis.enabled | bool | `false` |  |
| redis.auth.enabled | bool | `true` |  |
| redis.auth.password | string | `"secret"` |  |
| redis.auth.existingSecret | string | `""` |  |
| redis.architecture | string | `"standalone"` |  |
| redis.master.resourcesPreset | string | `"nano"` |  |
| redis.master.resources | object | `{}` |  |
| externalRedis.host | string | `""` |  |
| externalRedis.port | int | `6379` |  |
| externalRedis.password | string | `""` |  |
| externalRedis.existingSecret | string | `""` |  |
| externalRedis.existingSecretPasswordKey | string | `""` |  |
| clickhouse.enabled | bool | `false` |  |
| clickhouse.auth.username | string | `"hoppscotch"` |  |
| clickhouse.auth.password | string | `"secret"` |  |
| clickhouse.auth.existingSecret | string | `""` |  |
| clickhouse.resourcesPreset | string | `"nano"` |  |
| clickhouse.resources | object | `{}` |  |
| externalClickhouse.host | string | `""` |  |
| externalClickhouse.port | int | `8123` |  |
| externalClickhouse.user | string | `""` |  |
| externalClickhouse.password | string | `""` |  |
| externalClickhouse.existingSecret | string | `""` |  |
| externalClickhouse.existingSecretPasswordKey | string | `""` |  |
<!-- markdownlint-enable MD013 MD034 -->
