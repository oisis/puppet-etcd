# == Class: etcd::config
#
# This module configure etcd service
#
# Parameters:
#
# [*package_name*]
#   Define rpm/deb package name to install etcd
#   Defaults to etcd
#
# [*config_file_path*]
#   Where the config file should be put
#   Defaults to running
#
class etcd::config(
    $package_name     = $::etcd::package_name,
    $config_file_path = $::etcd::config_file_path,
  ) inherits etcd {
  validate_string($package_name)
  validate_absolute_path($config_file_path)

  file { $config_file_path:
    notify  => Service['etcd'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/etc/etcd/etcd.conf.erb"),
    require => Package[ $package_name ],
  }
}
