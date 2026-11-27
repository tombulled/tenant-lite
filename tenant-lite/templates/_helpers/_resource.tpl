{{- define "tenant.data" -}}
  {{- $id := .id }}
  {{- $data := .data }}

  {{- if ne $data.enabled false }}
    {{- if eq $data.name nil }}
      {{- $_ := set $data "name" $id }}
    {{- end }}

    {{- $data | toYaml }}
  {{- end }}
{{- end -}}
