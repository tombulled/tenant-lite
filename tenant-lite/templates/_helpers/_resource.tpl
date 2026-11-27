{{- define "tenant.data" -}}
  {{- /* Extract arguments */ -}}
  {{- $ := .root }}
  {{- $id := .id }}
  {{- $data := .data }}
  {{- $defaults := .defaults | default dict }}

  {{- /* Apply defaults */ -}}
  {{- $data = mustMergeOverwrite
    (deepCopy $.Values.defaults)
    (deepCopy $defaults)
    (deepCopy $data)
  }}

  {{- /* Propagate the resource ID so it can be used during self-templating */ -}}
  {{- $_ := set $data "id" $id }}

  {{- if ne $data.enabled false }}
    {{- /* Default the resource's name to its ID if a name isn't specified */ -}}
    {{- if eq $data.name nil }}
      {{- $_ := set $data "name" $id }}
    {{- end }}

    {{- /* Template the resource's name first */ -}}
    {{- $_ := set $data "name" (include "common.tplvalues.render" (dict "value" $data.name "context" $ "scope" $data)) }}

    {{- /* Template the resource's data using itself */ -}}
    {{- $data = include "common.tplvalues.render" (dict "value" $data "context" $ "scope" $data) | fromYaml }}

    {{- $data | toYaml }}
  {{- end }}
{{- end -}}

{{- define "tenant.datas" -}}
  {{- $ := .root }}
  {{- $values := .values }}
  {{- $defaults := .defaults }}

  {{- $datas := list }}

  {{- range $id, $data := $values }}
    {{- with include "tenant.data" (dict "root" $ "id" $id "data" $data "defaults" $defaults) | fromYaml }}
      {{- $datas = append $datas . }}
    {{- end }}
  {{- end }}

  {{- $datas | toYaml }}
{{- end -}}
