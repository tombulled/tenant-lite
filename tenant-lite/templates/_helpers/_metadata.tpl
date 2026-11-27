{{- define "tenant.field" -}}
  {{- $_args := concat . (list nil nil nil) -}}
  {{- $name := index $_args 0 -}}
  {{- $value := index $_args 1 -}}
  {{- $indent := index $_args 2 | default 0 -}}

  {{- if ne $value nil -}}
    {{- (dict $name $value) | toYaml | nindent $indent -}}
  {{- end -}}
{{- end -}}

{{- define "tenant.metadata" -}}
metadata:
  {{- include "tenant.field" (list "annotations" .annotations 2) }}
  {{- include "tenant.field" (list "finalizers" .finalizers 2) }}
  {{- include "tenant.field" (list "labels" .labels 2) }}
  {{- include "tenant.field" (list "name" .name 2) }}
  {{- include "tenant.field" (list "namespace" .namespace 2) }}
{{- end -}}

{{- define "tenant.metadata-omitting" -}}
  {{- $data := first . }}
  {{- $fields := rest . }}

  {{- $metadata := include "tenant.metadata" $data | fromYaml }}

  {{- range $field := $fields }}
    {{- $_ := unset $metadata.metadata $field }}
  {{- end }}

  {{- $metadata | toYaml }}
{{- end -}}
