# Class: etcd::install
#
# This module installs etcd package
#
# Parameters:
#
# [*manage_package*]
#   If the module should manage the package
#   Defaults to running
#
# [*package_ensure*]
#   Passed to the docker package.
#   Defaults to present
#
# [*package_name*]
#   Define rpm/deb package name to install etcd
#   Defaults to etcd
#
class etcd::install(
    $manage_package   = $::etcd::manage_package,
    $package_ensure   = $::etcd::package_ensure,
    $package_name     = $::etcd::package_name,
  ) inherits etcd {
  if $manage_package {
    package { 'etcd':
      ensure => $package_ensure,
      name   => $package_name,
    }
  }
}
