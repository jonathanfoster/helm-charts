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
| containerPorts.http | int | `80` |  |
| containerPorts.https | int | `443` |  |
| image.repository | string | `"hoppscotch/hoppscotch"` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.tag | string | `""` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| securityContext | object | `{}` |  |
| extraEnvs | list | `[]` |  |
| resources | object | `{}` |  |
| livenessProbe | object | `{}` |  |
| readinessProbe | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` |  |
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
| backend.databaseUrl | string | `""` |  |
| backend.aioAlternatePort | int | `80` |  |
| backend.jwtSecret | string | `"secret"` |  |
| backend.tokenSaltComplexity | int | `10` |  |
| backend.magicLinkTokenValidity | int | `3` |  |
| backend.refreshTokenValidity | string | `"604800000"` |  |
| backend.accessTokenValidity | string | `"86400000"` |  |
| backend.sessionSecret | string | `""` |  |
| backend.allowSecureCookies | bool | `true` |  |
| backend.dataEncryptionKey | string | `"12345678901234567890123456789012"` |  |
| backend.redirectUrl | string | `""` |  |
| backend.whitelistedOrigins | list | `[]` |  |
| backend.allowedAuthProviders[0] | string | `"email"` |  |
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
| enterprise.licenseKey | string | `""` |  |
| enterprise.frontend.localProxyServerEnabled | bool | `false` |  |
| enterprise.frontend.proxyAppUrl | string | `""` |  |
| enterprise.backend.githubEnterpriseAuth.enabled | bool | `false` |  |
| enterprise.backend.githubEnterpriseAuth.authorizationUrl | string | `""` |  |
| enterprise.backend.githubEnterpriseAuth.tokenUrl | string | `""` |  |
| enterprise.backend.githubEnterpriseAuth.userProfileUrl | string | `""` |  |
| enterprise.backend.githubEnterpriseAuth.userEmailUrl | string | `""` |  |
| enterprise.backend.samlAuth.issuer | string | `""` |  |
| enterprise.backend.samlAuth.audience | string | `""` |  |
| enterprise.backend.samlAuth.callbackUrl | string | `""` |  |
| enterprise.backend.samlAuth.cert | string | `""` |  |
| enterprise.backend.samlAuth.entryPoint | string | `""` |  |
| enterprise.backend.samlAuth.wantAssertionsSigned | bool | `true` |  |
| enterprise.backend.samlAuth.wantResponseSigned | bool | `false` |  |
| enterprise.backend.oidcAuth.providerName | string | `""` |  |
| enterprise.backend.oidcAuth.issuer | string | `""` |  |
| enterprise.backend.oidcAuth.authorizationUrl | string | `""` |  |
| enterprise.backend.oidcAuth.tokenUrl | string | `""` |  |
| enterprise.backend.oidcAuth.userInfoUrl | string | `""` |  |
| enterprise.backend.oidcAuth.clientId | string | `""` |  |
| enterprise.backend.oidcAuth.clientSecret | string | `""` |  |
| enterprise.backend.oidcAuth.callbackUrl | string | `""` |  |
| enterprise.backend.oidcAuth.scope | list | `[]` |  |
| enterprise.backend.clickhouse.allowAuditLogs | bool | `false` |  |
| enterprise.backend.clickhouse.host | string | `""` |  |
| enterprise.backend.clickhouse.user | string | `""` |  |
| enterprise.backend.clickhouse.password | string | `""` |  |
| enterprise.backend.horizontalScalingEnabled | bool | `false` |  |
| enterprise.backend.redisUrl | string | `""` |  |
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
| persistence.enabled | bool | `true` |  |
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
| defaultInitContainers.waitForDatabase.timeout | int | `60` |  |
| defaultInitContainers.waitForDatabaseSetup.enabled | bool | `true` |  |
| defaultInitContainers.waitForDatabaseSetup.timeout | int | `60` |  |
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
<!-- markdownlint-enable MD013 MD034 -->
