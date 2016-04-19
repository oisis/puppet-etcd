# == Class: etcd::service
#
# Class to manage the etcd service daemon
#
# Parameters:
#
# [*service_ensure*]
#   Whether you want to kube daemons to start up
#   Defaults to running
#
# [*manage_service*]
#   If the module should manage the service
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
class etcd::service(
    $service_ensure = $::etcd::service_ensure,
    $manage_service = $::etcd::manage_service,
    $service_enable = $::etcd::service_enable,
    $package_name   = $::etcd::package_name,
  ) inherits etcd {

  if ! ($service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  if $manage_service {
    service { 'etcd':
      ensure  => $service_ensure,
      enable  => $service_enable,
      require => Package[ $package_name ],
    }
  }
}
