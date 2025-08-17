{
    "Dhcp4": {
        "hooks-libraries": [{
            "library": "/usr/lib64/kea/hooks/libdhcp_lease_cmds.so"
        }],
        "interfaces-config": {
            {{ $interfaces := ( strings.Split "," ((index (ds "dhcp") "interfaces") )) }}
            {{ $l := ( len $interfaces ) }}
            "interfaces": [ {{ range $i, $interface := $interfaces }} {{ $interface | strings.Quote }}{{ if lt $i (add $l -1) }},{{ end }}{{ end }}  ]
        },
        "control-socket": {
            "socket-type": "unix",
            "socket-name": "/run/kea/kea4-ctrl-socket"
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
        "valid-lifetime": 4000,

	"client-classes": [
           {{ if and (index (ds "dhcp") "ipxe_http") (index (ds "dhcp") "next_server") }}
           {
              "name": "a-ipxe",
              "test": "option[77].hex == 'iPXE'",
	      "boot-file-name": {{ index (ds "dhcp") "ipxe_http" | strings.Quote }}
           },
	   {{ end }}
           {{ if and (index (ds "dhcp") "ipxe_legacy") (index (ds "dhcp") "next_server") }}
           {
              "name": "b-efi",
              "test": "option[93].hex == 0x0000",
	      "next-server": {{ index (ds "dhcp") "next_server" | strings.Quote }},
              "boot-file-name": {{ index (ds "dhcp") "ipxe_legacy" | strings.Quote }}
           },
	   {{ end }}
           {{ if and (index (ds "dhcp") "ipxe_efi") (index (ds "dhcp") "next_server") }}
           {
              "name": "ipxe-efi",
              "test": "option[93].hex == 0x0007",
	      "next-server": {{ index (ds "dhcp") "next_server" | strings.Quote }},
              "boot-file-name": {{ index (ds "dhcp") "ipxe_efi" | strings.Quote }}
           },
	   {{ end }}
        ],

        "subnet4": [
        {{ range $k, $v := (index (ds "dhcp")) }}
        {{ if $k | strings.HasPrefix "::" }}
        {
                "id": {{ index $v "id" }},
		"interface": {{ (index $v "interface") | strings.Quote }},	
                "option-data": [
                {{ if index $v "router" }}
                {
                    "name": "routers",
                    "data": "{{ index $v "router" }}"
                },
                {{ end }}
                {{ if (index $v "dns_servers") }}
                {
                    "name": "domain-name-servers",
                    "data": "{{ index $v "dns_servers" }}"
                }
                {{ end }}
                ],
                "subnet": {{ strings.Quote (index $v "subnet") }},
                {{ if  index $v "::pools" }}
                "pools": [
                    {{ $c := 0 }}
                    {{ $l := ( len (index $v "::pools") ) }}
                    {{ range $k, $v := (index $v "::pools") }} { {{ "pool" | strings.Quote }}: {{ strings.Quote $v }} }{{ if lt $c (add $l -1) }},{{ end }} {{ $c = (add $c 1) }}{{ end }}
                ],
                {{ end }}
		{{ if (index $v "::leases") }}
                "reservations": [
                {{ $c := 0 }}
                {{ $l := ( len (index $v "::leases") ) }}
                {{ range $hostname, $data := (index $v "::leases") }}{
                        {{ "hostname" | strings.Quote }}: {{ $hostname | strings.TrimLeft "::" | strings.Quote }},
                        {{ "hw-address" | strings.Quote }}: {{ index $data "mac" | strings.Quote }},
                        {{ "ip-address" | strings.Quote }}: {{ index $data "ip" | strings.Quote }}
                }{{ if lt $c (add $l -1) }},{{ end }}
                {{ $c = (add $c 1) }}
                {{ end }}
                ]
		{{ end }}
        },
        {{ end }}
        {{ end }}
        ],

        "loggers": [
                {
                    "name": "kea-dhcp4",
                    "output-options": [
                        {
                            "output": "/var/log/kea/kea-dhcp4.log"
                        }
                    ],
                    "severity": "DEBUG",
                    "debuglevel": 50
                }
        ]
    }
}
