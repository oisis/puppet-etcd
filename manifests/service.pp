# == Class: etcd::service
#
# Class to manage the etcd service daemon
#
class etcd::service {

  if ! ($::etcd::service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if $::etcd::manage_service {
    service { 'etcd':
      ensure => $::etcd::service_ensure,
      enable => $::etcd::service_enable,
    }
  }
}
