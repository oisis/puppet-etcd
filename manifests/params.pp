# == Class: etcd::params
#
# Default parameter values for the etcd module
#
class etcd::params {
  $ensure = 'present'
  $manage_package = true
  $manage_service = true

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

  $service_ensure = 'running'
  $service_enable = true
  # member options
  $wal_dir = ''
  $snapshot_counter = undef
  $heartbeat_interval = undef
  $election_timeout = undef
  $listen_client_urls = ['http://0.0.0.0:2379']
  $advertise_client_urls = ['http://localhost:2379']
  $max_snapshots = undef
  $max_wals = undef
  $cors = undef

  # cluster options
  $listen_peer_urls = ['http://localhost:2380', 'http://localhost:4001']
  $initial_advertise_peer_urls = ['http://localhost:2380']
  $initial_cluster_state = undef
  $initial_cluster_token = undef
  $discovery = undef
  $discovery_srv = undef
  $discovery_fallback = undef
  $discovery_proxy = undef
  $strict_reconfig_check = undef

  # proxy
  $proxy = undef
  $proxy_failure_wait = undef
  $proxy_refresh_interval = undef
  $proxy_dial_timeout = undef
  $proxy_write_timeout = undef
  $proxy_read_timeout = undef

  # security
  $cert_file = undef
  $key_file = undef
  $client_cert_auth = undef
  $trusted_ca_file = undef
  $peer_cert_file = undef
  $peer_key_file = undef
  $peer_client_cert_auth = undef
  $peer_trusted_ca_file = undef

  # logging
  $debug = false
  $log_package_levels = undef
}
