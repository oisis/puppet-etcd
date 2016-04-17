# == Class: etcd::config
#
class etcd::config {
  file { $::etcd::config_file_path:
    notify  => Service['etcd'],
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/etc/etcd/etcd.conf.erb"),
    require => Package[ $::etcd::etcd_packagename ],
  }
}
