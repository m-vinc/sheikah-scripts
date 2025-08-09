{
    "Dhcp6": {
        "hooks-libraries": [{
            "library": "/usr/lib64/kea/hooks/libdhcp_lease_cmds.so"
        }],
        "interfaces-config": {
            "interfaces": [ {{ index (ds "dhcp") "interface" | strings.Quote }} ]
        },
        "control-socket": {
            "socket-type": "unix",
            "socket-name": "/run/kea/kea6-ctrl-socket"
        },
        "lease-database": {
            "type": "memfile",
            "lfc-interval": 3600
        },
        "expired-leases-processing": {
            "reclaim-timer-wait-time": 10,
            "flush-reclaimed-timer-wait-time": 25,
            "hold-reclaimed-time": 3600,
            "max-reclaim-leases": 100,
            "max-reclaim-time": 250,
            "unwarned-reclaim-cycles": 5
        },

        "renew-timer": 1000,
        "rebind-timer": 2000,
        "preferred-lifetime": 3000,
        "valid-lifetime": 4000,
        "subnet6": [
        {{ range $k, $v := (ds "dhcp") }}
        {{ if $k | strings.HasPrefix "::" }}
        {
            "id": {{ (index $v "id") }},
            "subnet": {{ strings.Quote (index $v "subnet") }},
            "option-data": [
                {{ if (index $v "dns_servers") }}
                {
                    "name": "dns-servers",
                    "data": "{{ index $v "dns_servers" }}"
                }
                {{ end }}
            ],
            {{ if  index $v "::pools" }}
            "pools": [
                {{ $c := 0 }}
                {{ $l := ( len (index $k "::pools") ) }}
                {{ range $k, $v := (index $v  "::pools") }} { {{ "pool" | strings.Quote }}: {{ strings.Quote $v }} }{{ if lt $c (add $l -1) }},{{ end }} {{ $c = (add $c 1) }}{{ end }}
            ],
            {{ end }}
            "reservations": [
            {{ $c := 0 }}
            {{ $l := ( len (index $v "::leases") ) }}
            {{ range $hostname, $data := (index $v "::leases") }}{
                    {{ "hostname" | strings.Quote }}: {{ $hostname | strings.TrimLeft "::" | strings.Quote }},
                    {{ "duid" | strings.Quote }}: {{ index $data "duid" | strings.Quote }},
                    {{ "ip-addresses" | strings.Quote }}: [{{ index $data "ip" | strings.Quote }}]
            }{{ if lt $c (add $l -1) }},{{ end }}
            {{ $c = (add $c 1) }}
            {{ end }}
            ]
        },
        {{ end }}
        {{ end }}
        ],
        "loggers": [
                {
                    "name": "kea-dhcp6",
                    "output-options": [
                        {
                            "output": "/var/log/kea/kea-dhcp6.log"
                        }
                    ],
                    "severity": "DEBUG",
                    "debuglevel": 50
                }
        ]
    }
}
