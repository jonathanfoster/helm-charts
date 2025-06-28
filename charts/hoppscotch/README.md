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

<!-- markdownlint-disable MD013 -->

### Global parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| imagePullSecrets | list | `[]` | This is for the secrets for pulling an image from a private repository. |

### Common parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| nameOverride | string | `""` | This is to override the chart name. |
| fullnameOverride | string | `""` | This is to override the fully qualified app name. |

### Hoppscotch common parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| replicaCount | int | `1` | This will set the replicaset count. |
| image.repository | string | `"nginx"` | This sets the image repository. |
| image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| image.tag | string | `"latest"` | Overrides the image tag whose default is the chart appVersion. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.automount | bool | `true` | Automatically mount a ServiceAccount's API credentials? |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| podAnnotations | object | `{}` | This is for setting Kubernetes Annotations to a Pod. |
| podLabels | object | `{}` | This is for setting Kubernetes Labels to a Pod. |
| service.type | string | `"ClusterIP"` | This sets the service type. |
| service.port | int | `80` | This sets the ports. |
| livenessProbe | object | `{"httpGet":{"path":"/","port":"http"}}` | This is to setup the liveness and readiness probes. |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | This section is for setting up autoscaling. |
| volumes | list | `[]` | Additional volumes on the output Deployment definition. |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |

### Database parameters

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| postgresql.enabled | bool | `true` | Switch to enable or disable the PostgreSQL helm chart |
| postgresql.auth.enablePostgresUser | bool | `true` | Assign a password to the "postgres" admin user. Otherwise, remote access will be blocked for this user |
| postgresql.auth.username | string | `"hoppscotch"` | Name for a custom user to create |
| postgresql.auth.password | string | `""` | Password for the custom user to create |
| postgresql.auth.database | string | `"hoppscotch"` | Name for a custom database to create |
| postgresql.architecture | string | `"standalone"` | PostgreSQL architecture (`standalone` or `replication`) |
| postgresql.primary.resourcesPreset | string | `"nano"` | PostgreSQL Primary resource requests and limits ref: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/ Set container resources according to one common preset (allowed values: none, nano, micro, small, medium, large, xlarge, 2xlarge). This is ignored if primary.resources is set (primary.resources is recommended for production). More information: https://github.com/bitnami/charts/blob/main/bitnami/common/templates/_resources.tpl#L15  |
| postgresql.primary.resources | object | `{}` | Set container requests and limits for different resources like CPU or memory (essential for production workloads) Example: resources:   requests:     cpu: 2     memory: 512Mi   limits:     cpu: 3     memory: 1024Mi  |
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
| resources | object | `{}` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| nodeSelector | object | `{}` |  |
| tolerations | list | `[]` |  |
| affinity | object | `{}` |  |
| postgresql.auth.existingSecret | string | `""` |  |
<!-- markdownlint-enable MD013 -->
