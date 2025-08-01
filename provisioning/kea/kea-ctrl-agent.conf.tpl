// This is a basic configuration for the Kea Control Agent.
//
// This is just a very basic configuration. Kea comes with large suite (over 30)
// of configuration examples and extensive Kea User's Guide. Please refer to
// those materials to get better understanding of what this software is able to
// do. Comments in this configuration file sometimes refer to sections for more
// details. These are section numbers in Kea User's Guide. The version matching
// your software should come with your Kea package, but it is also available
// in ISC's Knowledgebase (https://kea.readthedocs.io; the direct link for
// the stable version is https://kea.readthedocs.io/).
//
// This configuration file contains only Control Agent's configuration.
// If configurations for other Kea services are also included in this file they
// are ignored by the Control Agent.
{

// This is a basic configuration for the Kea Control Agent.
// RESTful interface to be available at http://127.0.0.1:8000/
"Control-agent": {
    "http-host": "127.0.0.1",
    // If enabling HA and multi-threading, the 8000 port is used by the HA
    // hook library http listener. When using HA hook library with
    // multi-threading to function, make sure the port used by dedicated
    // listener is different (e.g. 8001) than the one used by CA. Note
    // the commands should still be sent via CA. The dedicated listener
    // is specifically for HA updates only.
    "http-port": 8000,

    // Allow access only to kea-api user.
    // To make it work, please store your password in kea-api-password file.
    // Make sure the password file has sufficiently restrictive access permissions,
    // in particular it is not world-readable.
    // The basic HTTP auth offers poor security for unencrypted channels.
    // If possible, a better, stronger HTTPS mechanism should be deployed,
    // in particular when the client authentication is enabled by setting the
    // cert-required to true (the default). See trust-anchor, cert-file,
    // key-file and cert-required below. For more details read the Kea Security
    // section in the ARM.
    // "authentication": {
    //     "type": "basic",
    //     "realm": "Kea Control Agent",
    //     "directory": "/etc/kea",
    //     "clients": [
    //         {
    //             "user": "kea-api",
    //             "password-file": "kea-api-password"
    //         }
    //     ]
    // },

    // Configuration section containing HTTPS parameters:
    // TLS trust anchor (Certificate Authority). This is a file name or
    // (for OpenSSL only) a directory path.
    // "trust-anchor": "kea-server-ca",
    // TLS server certificate file name.
    // "cert-file": "kea-server-cert",
    // TLS server private key file name.
    // "key-file": "kea-server-key",
    // TLS require client certificates flag. Default is true and means
    // require client certificates. False means they are optional.
    // "cert-required": true

    // Specify location of the files to which the Control Agent
    // should connect to forward commands to the DHCPv4, DHCPv6
    // and D2 servers via unix domain sockets.
    "control-sockets": {
        "dhcp4": {
            "socket-type": "unix",
            "socket-name": "kea4-ctrl-socket"
        },
        "dhcp6": {
            "socket-type": "unix",
            "socket-name": "kea6-ctrl-socket"
        },
        "d2": {
            "socket-type": "unix",
            "socket-name": "kea-ddns-ctrl-socket"
        }
    },

    // Specify hooks libraries that are attached to the Control Agent.
    // Such hooks libraries should support 'control_command_receive'
    // hook point. This is currently commented out because it has to
    // point to the existing hooks library. Otherwise the Control
    // Agent will fail to start.
    "hooks-libraries": [
//  {
//      "library": "/usr/lib64/kea/hooks/control-agent-commands.so",
//      "parameters": {
//          "param1": "foo"
//      }
//  }
    ],

// Logging configuration starts here. Kea uses different loggers to log various
// activities. For details (e.g. names of loggers), see Chapter 18.
    "loggers": [
    {
        // This specifies the logging for Control Agent daemon.
        "name": "kea-ctrl-agent",
        "output-options": [
            {
                // Specifies the output file. There are several special values
                // supported:
                // - stdout (prints on standard output)
                // - stderr (prints on standard error)
                // - syslog (logs to syslog)
                // - syslog:name (logs to syslog using specified name)
                // Any other value is considered a name of the file
                "output": "kea-ctrl-agent.log"

                // Shorter log pattern suitable for use with systemd,
                // avoids redundant information
                // "pattern": "%-5p %m\n"

                // This governs whether the log output is flushed to disk after
                // every write.
                // "flush": false,

                // This specifies the maximum size of the file before it is
                // rotated.
                // "maxsize": 1048576,

                // This specifies the maximum number of rotated files to keep.
                // "maxver": 8
            }
        ],
        // This specifies the severity of log messages to keep. Supported values
        // are: FATAL, ERROR, WARN, INFO, DEBUG
        "severity": "INFO",

        // If DEBUG level is specified, this value is used. 0 is least verbose,
        // 99 is most verbose. Be cautious, Kea can generate lots and lots
        // of logs if told to do so.
        "debuglevel": 0
    }
  ]
}
}
