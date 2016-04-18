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
# [*ensure*]
#   Passed to the docker package.
#   Defaults to present
#
# [*etcd_packagename*]
#   Define rpm/deb package name to install etcd
#   Defaults to etcd
#
class etcd::install(
    $manage_package   = $::etcd::manage_package,
    $ensure           = $::etcd::ensure,
    $package_name = $::etcd::etcd_packagename,
  ) inherits etcd {
  if $manage_package {
    package { 'etcd':
      ensure => $ensure,
      name   => $package_name,
    }
  }
}
