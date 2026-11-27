{{- define "tenant.data" -}}
  {{- $root := .root }}
  {{- $id := .id }}
  {{- $data := .data }}

  {{- if ne $data.enabled false }}
    {{- if eq $data.name nil }}
      {{- $_ := set $data "name" $id }}
    {{- end }}

    {{- /* Template the resource's data using itself */ -}}
    {{- $data = include "common.tplvalues.render" (dict "value" $data "context" $root "scope" $data) | fromYaml }}

    {{- $data | toYaml }}
  {{- end }}
{{- end -}}
