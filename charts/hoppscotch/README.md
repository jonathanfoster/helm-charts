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
| existingSecret | string | `""` |  |
| replicaCount | int | `1` |  |
| containerPorts.http | int | `80` |  |
| containerPorts.https | int | `443` |  |
| image.repository | string | `"hoppscotch/hoppscotch"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| securityContext | object | `{}` |  |
| extraEnvVars | list | `[]` |  |
| extraEnvVarsCM | string | `""` |  |
| extraEnvVarsSecret | string | `""` |  |
| resources | object | `{}` |  |
| resourcesPreset | string | `"nano"` |  |
| livenessProbe | object | `{}` |  |
| readinessProbe | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
| updateStrategy.type | string | `"RollingUpdate"` |  |
| updateStrategy.rollingUpdate.maxUnavailable | int | `1` |  |
| updateStrategy.rollingUpdate.maxSurge | int | `1` |  |
| volumes | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| topologySpreadConstraints | list | `[]` |  |
| setupDatabaseJob.enabled | bool | `true` |  |
| frontend.baseUrl | string | `""` |  |
| frontend.shortcodeBaseUrl | string | `""` |  |
| frontend.adminUrl | string | `""` |  |
| frontend.backendGqlUrl | string | `""` |  |
| frontend.backendWsUrl | string | `""` |  |
| frontend.backendApiUrl | string | `""` |  |
| frontend.appTosLink | string | `""` |  |
| frontend.appPrivacyPolicyLink | string | `""` |  |
| frontend.enableSubpathBasedAccess | bool | `true` |  |
| frontend.localProxyServerEnabled | bool | `false` |  |
| frontend.proxyAppUrl | string | `""` |  |
| backend.databaseUrl | string | `""` |  |
| backend.aioAlternatePort | int | `80` |  |
| backend.authToken.jwtSecret | string | `"secret"` |  |
| backend.authToken.tokenSaltComplexity | int | `10` |  |
| backend.authToken.magicLinkTokenValidity | int | `3` |  |
| backend.authToken.refreshTokenValidity | string | `"604800000"` |  |
| backend.authToken.accessTokenValidity | string | `"86400000"` |  |
| backend.authToken.sessionSecret | string | `"secret"` |  |
| backend.allowSecureCookies | bool | `true` |  |
| backend.dataEncryptionKey | string | `"12345678901234567890123456789012"` |  |
| backend.redirectUrl | string | `""` |  |
| backend.whitelistedOrigins | list | `[]` |  |
| backend.auth.allowedProviders[0] | string | `"email"` |  |
| backend.auth.google.clientId | string | `""` |  |
| backend.auth.google.clientSecret | string | `""` |  |
| backend.auth.google.callbackUrl | string | `""` |  |
| backend.auth.google.scope | list | `[]` |  |
| backend.auth.github.clientId | string | `""` |  |
| backend.auth.github.clientSecret | string | `""` |  |
| backend.auth.github.callbackUrl | string | `""` |  |
| backend.auth.github.scope | list | `[]` |  |
| backend.auth.githubEnterprise.enabled | bool | `false` |  |
| backend.auth.githubEnterprise.authorizationUrl | string | `""` |  |
| backend.auth.githubEnterprise.tokenUrl | string | `""` |  |
| backend.auth.githubEnterprise.userProfileUrl | string | `""` |  |
| backend.auth.githubEnterprise.userEmailUrl | string | `""` |  |
| backend.auth.microsoft.clientId | string | `""` |  |
| backend.auth.microsoft.clientSecret | string | `""` |  |
| backend.auth.microsoft.callbackUrl | string | `""` |  |
| backend.auth.microsoft.scope | string | `""` |  |
| backend.auth.microsoft.tenant | string | `""` |  |
| backend.auth.oidc.providerName | string | `""` |  |
| backend.auth.oidc.issuer | string | `""` |  |
| backend.auth.oidc.authorizationUrl | string | `""` |  |
| backend.auth.oidc.tokenUrl | string | `""` |  |
| backend.auth.oidc.userInfoUrl | string | `""` |  |
| backend.auth.oidc.clientId | string | `""` |  |
| backend.auth.oidc.clientSecret | string | `""` |  |
| backend.auth.oidc.callbackUrl | string | `""` |  |
| backend.auth.oidc.scope | list | `[]` |  |
| backend.auth.saml.issuer | string | `""` |  |
| backend.auth.saml.audience | string | `""` |  |
| backend.auth.saml.callbackUrl | string | `""` |  |
| backend.auth.saml.cert | string | `""` |  |
| backend.auth.saml.entryPoint | string | `""` |  |
| backend.auth.saml.wantAssertionsSigned | bool | `true` |  |
| backend.auth.saml.wantResponseSigned | bool | `false` |  |
| backend.mailer.smtpEnabled | bool | `true` |  |
| backend.mailer.useCustomConfigs | bool | `false` |  |
| backend.mailer.addressFrom | string | `"no-reply@example.com"` |  |
| backend.mailer.smtpUrl | string | `"smtps://user:pass@smtp.example.com"` |  |
| backend.mailer.smtpHost | string | `""` |  |
| backend.mailer.smtpPort | int | `465` |  |
| backend.mailer.smtpSecure | bool | `true` |  |
| backend.mailer.smtpUser | string | `""` |  |
| backend.mailer.smtpPassword | string | `""` |  |
| backend.mailer.tlsRejectUnauthorized | bool | `true` |  |
| backend.rateLimit.ttl | int | `60` |  |
| backend.rateLimit.max | int | `100` |  |
| backend.enterpriseLicenseKey | string | `""` |  |
| backend.clickhouse.allowAuditLogs | bool | `false` |  |
| backend.clickhouse.host | string | `""` |  |
| backend.clickhouse.user | string | `""` |  |
| backend.clickhouse.password | string | `""` |  |
| backend.horizontalScalingEnabled | bool | `false` |  |
| backend.redisUrl | string | `""` |  |
| service.type | string | `"ClusterIP"` |  |
| service.ports.http | int | `80` |  |
| service.ports.https | int | `443` |  |
| service.nodePorts.http | string | `""` |  |
| service.nodePorts.https | string | `""` |  |
| service.clusterIP | string | `""` |  |
| service.loadBalancerIP | string | `""` |  |
| service.loadBalancerSourceRanges | list | `[]` |  |
| service.externalTrafficPolicy | string | `"Cluster"` |  |
| service.annotations | object | `{}` |  |
| service.extraPorts | list | `[]` |  |
| service.sessionAffinity | string | `"None"` |  |
| service.sessionAffinityConfig | object | `{}` |  |
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
| ingress.pathType | string | `"ImplementationSpecific"` |  |
| ingress.apiVersion | string | `""` |  |
| ingress.hostname | string | `"hoppscotch.local"` |  |
| ingress.ingressClassName | string | `""` |  |
| ingress.path | string | `"/"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.tls | bool | `false` |  |
| ingress.selfSigned | bool | `false` |  |
| ingress.extraHosts | list | `[]` |  |
| ingress.extraPaths | list | `[]` |  |
| ingress.extraTls | list | `[]` |  |
| ingress.secrets | list | `[]` |  |
| ingress.extraRules | list | `[]` |  |
| persistence.enabled | bool | `false` |  |
| persistence.mountPath | string | `"/hoppscotch/data"` |  |
| persistence.subPath | string | `""` |  |
| persistence.storageClass | string | `""` |  |
| persistence.annotations | object | `{}` |  |
| persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistence.size | string | `"8Gi"` |  |
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
| rbac.create | bool | `false` |  |
| rbac.rules | list | `[]` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| metrics.enabled | bool | `false` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
| metrics.serviceMonitor.namespace | string | `""` |  |
| metrics.serviceMonitor.annotations | object | `{}` |  |
| metrics.serviceMonitor.labels | object | `{}` |  |
| metrics.serviceMonitor.jobLabel | string | `""` |  |
| metrics.serviceMonitor.honorLabels | bool | `false` |  |
| metrics.serviceMonitor.tlsConfig | object | `{}` |  |
| metrics.serviceMonitor.interval | string | `""` |  |
| metrics.serviceMonitor.scrapeTimeout | string | `""` |  |
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
