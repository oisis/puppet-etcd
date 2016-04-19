# == Class: etcd::params
#
# Default parameter values for the etcd module
#
# Parameters:
#
# [*package_ensure*]
#   Passed to the docker package.
#   Defaults to present
#
# [*manage_package*]
#   If the module should manage the package
#   Defaults to running
#
# [*manage_service*]
#   If the module should manage the service
#   Defaults to running
#
# [*config_file_path*]
#   Where the config file should be put
#   Defaults to running
#
# [*service_ensure*]
#   Whether you want to kube daemons to start up
#   Defaults to running
#
# [*service_enable*]
#   Whether you want to kube daemons to start up at boot
#   Defaults to true
#
# [*package_name*]
#   Define rpm/deb package name to install etcd
#   Defaults to etcd
#
#  member
# [*etcd_name*]
#   Human-readable name for this member.
#   Default: "default"
#
# [*data_dir*]
#   Path to the data directory.
#   default: "${name}.etcd"
#
# [*wal_dir*]
#   Path to the dedicated wal directory. If this flag is set, etcd will write the WAL
#   files to the walDir rather than the dataDir. This allows a dedicated disk to be used,
#   and helps avoid io competition between logging and other IO operations.
#   default: ""
#
# [*snapshot_count*]
#   Number of committed transactions to trigger a snapshot to disk.
#   default: "10000"
#
# [*heartbeat_interval*]
#   Time (in milliseconds) of a heartbeat interval.
#   default: "100"
#
# [*election_timeout*]
#   Time (in milliseconds) for an election to timeout. See Documentation/tuning.md for details.
#   default: "1000"
#
# [*listen_peer_urls*]
#   List of URLs to listen on for peer traffic. This flag tells the etcd to accept incoming
#   requests from its peers on the specified scheme://IP:port combinations. Scheme can be either
#   http or https.If 0.0.0.0 is specified as the IP, etcd listens to the given port on all interfaces.
#   If an IP address is given as well as a port, etcd will listen on the given port and interface.
#   Multiple URLs may be used to specify a number of addresses and ports to listen on. The etcd will
#   respond to requests from any of the listed addresses and ports.
#   default: "http://localhost:2380,http://localhost:7001"
#
# [*listen_client_urls*]
#   List of URLs to listen on for client traffic. This flag tells the etcd to accept incoming requests
#   from the clients on the specified scheme://IP:port combinations. Scheme can be either http or https.
#   If 0.0.0.0 is specified as the IP, etcd listens to the given port on all interfaces. If an IP address
#   is given as well as a port, etcd will listen on the given port and interface. Multiple URLs may be used
#   to specify a number of addresses and ports to listen on. The etcd will respond to requests from any of
#   the listed addresses and ports.
#   default: "http://localhost:2379,http://localhost:4001"
#
# [*max_snapshots*]
#   Maximum number of snapshot files to retain (0 is unlimited)
#   default: 5
#
# [*max_wals*]
#   Maximum number of wal files to retain (0 is unlimited)
#   default: 5
#
# [*cors*]
#   Comma-separated white list of origins for CORS (cross-origin resource sharing).
#   default: none
#
# cluster
# [*initial_advertise_peer_urls*]
#   List of this member's peer URLs to advertise to the rest of the cluster. These addresses
#   are used for communicating etcd data around the cluster. At least one must be routable to
#   all cluster members. These URLs can contain domain names.
#   default: "http://localhost:2380,http://localhost:7001"
#
# [*initial_cluster*]
#   Initial cluster configuration for bootstrapping.
#   default: "default=http://localhost:2380,default=http://localhost:7001"
#
# [*initial_cluster_state*]
#   Initial cluster state ("new" or "existing"). Set to new for all members present during initial
#   static or DNS bootstrapping. If this option is set to existing, etcd will attempt to join the
#   existing cluster. If the wrong value is set, etcd will attempt to start but fail safely.
#   default: "new"
#
# [*initial_cluster_token*]
#   Initial cluster token for the etcd cluster during bootstrap.
#   default: "etcd-cluster"
#
# [*advertise_client_urls*]
#   List of this member's client URLs to advertise to the rest of the cluster. These URLs can contain domain names.
#   default: "http://localhost:2379,http://localhost:4001"
#
# [*discovery*]
#   Discovery URL used to bootstrap the cluster.
#   default: none
#
# [*discovery_srv*]
#   DNS srv domain used to bootstrap the cluster.
#   default: none
#
# [*discovery_fallback*]
#   Expected behavior ("exit" or "proxy") when discovery services fails.
#   default: "proxy"
#
# [*discovery_proxy*]
#   HTTP proxy to use for traffic to discovery service.
#   default: none
#
# [*strict_reconfig_check*]
#   Reject reconfiguration requests that would cause quorum loss.
#   default: false
#
# proxy
# [*proxy*]
#   Proxy mode setting ("off", "readonly" or "on").
#   default: "off"
#
# [*proxy_failure_wait*]
#   Time (in milliseconds) an endpoint will be held in a failed state before being reconsidered for proxied requests.
#   default: 5000
#
# [*proxy_refresh_interval*]
#   Time (in milliseconds) of the endpoints refresh interval.
#   default: 30000
#
# [*proxy_dial_timeout*]
#   Time (in milliseconds) for a dial to timeout or 0 to disable the timeout
#   default: 1000
#
# [*proxy_write_timeout*]
#   Time (in milliseconds) for a write to timeout or 0 to disable the timeout.
#   default: 5000
#
# [*proxy_read_timeout*]
#   Time (in milliseconds) for a read to timeout or 0 to disable the timeout.
#   Don't change this value if you use watches because they are using long polling requests.
#   default: 0
#
# security
# [*cert_file*]
#   Path to the client server TLS cert file.
#   default: none
#
# [*key_file*]
#   Path to the client server TLS key file.
#   default: none
#
# [*client_cert_auth*]
#   Enable client cert authentication.
#   default: false
#
# [*trusted_ca_file*]
#   Path to the client server TLS trusted CA key file.
#   default: none
#
# [*peer_cert_file*]
#   Path to the peer server TLS cert file.
#   default: none
#
# [*peer_key_file*]
#   Path to the peer server TLS key file.
#   default: none
#
# [*peer_client_cert_auth*]
#   Enable peer client cert authentication.
#   default: false
#
# [*peer_trusted_ca_file*]
#   Path to the peer server TLS trusted CA file.
#   default: none
#
# logging
# [*debug*]
#   Drop the default log level to DEBUG for all subpackages.
#   default: false (INFO for all packages)
#
# [*log_package_levels*]
#   Set individual etcd subpackages to specific log levels. An example being etcdserver=WARNING,security=DEBUG
#   default: none (INFO for all packages)
#
class etcd::params {
  $package_ensure               = 'present'
  $manage_package               = true
  $manage_service               = true
  # service options
  $service_ensure               = 'running'
  $service_enable               = true
  $package_name                 = 'etcd'
  # member options
  $etcd_name                    = 'default'
  $data_dir                     = "/var/lib/etcd/${etcd_name}.etcd"
  $wal_dir                      = ''
  $snapshot_count               = undef
  $heartbeat_interval           = undef
  $election_timeout             = undef
  $listen_peer_urls             = undef
  $listen_client_urls           = ['http://localhost:2379']
  $max_snapshots                = undef
  $max_wals                     = undef
  $cors                         = undef
  # cluster options
  $initial_advertise_peer_urls  = undef
  $initial_cluster              = ["${etcd_name}=http://localhost:2380", "${etcd_name}=http://localhost:7001"]
  $initial_cluster_state        = undef
  $initial_cluster_token        = undef
  $advertise_client_urls        = ['http://localhost:2379']
  $discovery                    = undef
  $discovery_srv                = undef
  $discovery_fallback           = undef
  $discovery_proxy              = undef
  # proxy
  $proxy                        = undef
  $proxy_failure_wait           = undef
  $proxy_refresh_interval       = undef
  $proxy_dial_timeout           = undef
  $proxy_write_timeout          = undef
  $proxy_read_timeout           = undef
  # security
  $cert_file                    = undef
  $key_file                     = undef
  $client_cert_auth             = undef
  $trusted_ca_file              = undef
  $peer_cert_file               = undef
  $peer_key_file                = undef
  $peer_client_cert_auth        = undef
  $peer_trusted_ca_file         = undef
  # logging
  $debug                        = undef
  $log_package_levels           = undef

  case $::osfamily {
    'RedHat' : {
      case $::operatingsystemmajrelease {
        '6'     : { $config_file_path = '/etc/sysconfig/etcd.conf' }
        '7'     : { $config_file_path = '/etc/etcd/etcd.conf' }
        default : { fail('Unsupported RedHat release.') }
      }
    }
    'Debian' : {
      $config_file_path = '/etc/default/etcd.conf'
    }
    default  : {
      fail('Unsupported OS.')
    }
  }
}
