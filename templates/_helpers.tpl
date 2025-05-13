{{/*
Expand the name of the chart.
*/}}
{{- define "typebot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "typebot.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "typebot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "typebot.labels" -}}
helm.sh/chart: {{ include "typebot.chart" . }}
{{ include "typebot.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "typebot.selectorLabels" -}}
app.kubernetes.io/name: {{ include "typebot.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "typebot.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "typebot.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return PostgreSQL host
*/}}
{{- define "typebot.postgresql.host" -}}
{{- if .Values.postgresql.enabled }}
    {{- $postgresqlReleaseName := .Release.Name -}}
    {{- printf "%s-postgresql" $postgresqlReleaseName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL port
*/}}
{{- define "typebot.postgresql.port" -}}
{{- if .Values.postgresql.enabled }}
    {{- printf "5432" -}}
{{- else -}}
    {{- .Values.externalDatabase.port -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL username
*/}}
{{- define "typebot.postgresql.username" -}}
{{- if .Values.postgresql.enabled }}
    {{- .Values.postgresql.auth.username -}}
{{- else -}}
    {{- .Values.externalDatabase.user -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL password
*/}}
{{- define "typebot.postgresql.password" -}}
{{- if .Values.postgresql.enabled }}
    {{- .Values.postgresql.auth.password -}}
{{- else -}}
    {{- .Values.externalDatabase.password -}}
{{- end -}}
{{- end -}}

{{/*
Return PostgreSQL database name
*/}}
{{- define "typebot.postgresql.database" -}}
{{- if .Values.postgresql.enabled }}
    {{- .Values.postgresql.auth.database -}}
{{- else -}}
    {{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{/*
Return Redis host
*/}}
{{- define "typebot.redis.host" -}}
{{- if .Values.redis.enabled }}
    {{- printf "%s-redis-master" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- .Values.externalRedis.host -}}
{{- end -}}
{{- end -}}

{{/*
Return Redis port
*/}}
{{- define "typebot.redis.port" -}}
{{- if .Values.redis.enabled }}
    {{- printf "6379" -}}
{{- else -}}
    {{- .Values.externalRedis.port -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO/S3 access key
*/}}
{{- define "typebot.s3.accessKey" -}}
{{- if .Values.minio.enabled }}
    {{- .Values.minio.auth.rootUser -}}
{{- else -}}
    {{- .Values.externalStorage.s3.accessKey -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO/S3 secret key
*/}}
{{- define "typebot.s3.secretKey" -}}
{{- if .Values.minio.enabled }}
    {{- .Values.minio.auth.rootPassword -}}
{{- else -}}
    {{- .Values.externalStorage.s3.secretKey -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO/S3 bucket name
*/}}
{{- define "typebot.s3.bucket" -}}
{{- if .Values.minio.enabled }}
    {{- .Values.minio.defaultBuckets -}}
{{- else -}}
    {{- .Values.externalStorage.s3.bucket -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO/S3 endpoint
*/}}
{{- define "typebot.s3.endpoint" -}}
{{- if .Values.minio.enabled }}
    {{- printf "%s-minio" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
    {{- .Values.externalStorage.s3.endpoint -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO/S3 port
*/}}
{{- define "typebot.s3.port" -}}
{{- if .Values.minio.enabled }}
    {{- printf "9000" -}}
{{- else -}}
    {{- .Values.externalStorage.s3.port -}}
{{- end -}}
{{- end -}}

{{/*
Return MinIO/S3 SSL setting
*/}}
{{- define "typebot.s3.ssl" -}}
{{- if .Values.minio.enabled }}
    {{- printf "false" -}}
{{- else -}}
    {{- .Values.externalStorage.s3.ssl -}}
{{- end -}}
{{- end -}}

{{/*
Return builder name
*/}}
{{- define "typebot.builder.name" -}}
{{- printf "%s-builder" (include "typebot.fullname" .) -}}
{{- end -}}

{{/*
Return viewer name
*/}}
{{- define "typebot.viewer.name" -}}
{{- printf "%s-viewer" (include "typebot.fullname" .) -}}
{{- end -}} 