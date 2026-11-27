{{- define "tenant.data" -}}
  {{- $ := .root }}
  {{- $id := .id }}
  {{- $data := .data }}
  {{- $defaults := .defaults }}

  {{- /* Merge the resource data with defaults */ -}}
    {{- $data = mustMergeOverwrite
    (dict)
    ($.Values.defaults | default dict | deepCopy)
    ($defaults | default dict | deepCopy)
    (deepCopy $data)
  }}

  {{- /* Propagate the resource ID so it can be used during self-templating */ -}}
  {{- $_ := set $data "id" $id }}

  {{- if ne $data.enabled false }}
    {{- /* Default the resource's name to its ID if a name isn't specified */ -}}
    {{- if eq $data.name nil }}
      {{- $_ := set $data "name" $id }}
    {{- end }}

    {{- /* Template the resource's data using itself */ -}}
    {{- $data = include "common.tplvalues.render" (dict "value" $data "context" $ "scope" $data) | fromYaml }}

    {{- $data | toYaml }}
  {{- end }}
{{- end -}}
