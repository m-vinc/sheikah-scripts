{{ with (ds "caddy") -}}
{{ .name }} {
        {{ if and (index . "tls_cert") (index . "tls_key") -}}
        tls {{ index . "tls_cert" }} {{ index . "tls_key" }}
        {{ end -}}

        {{ if and (index . "file_server")  (index . "path") -}}
        handle_path {{ index . "path" }} {
                root * {{ index . "root" }}
                file_server {
                        {{ if eq (index . "browse") "true" }}browse{{ end }}
                }
        }
        {{- end }}
}
{{ end -}}

