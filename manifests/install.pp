# == Class: etcd
#
class etcd::install {
  if $::etcd::manage_package {
    package { $::etcd::etcd_packagename :
      ensure => $::etcd::ensure,
    }
  }
}
