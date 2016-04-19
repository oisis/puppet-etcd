# etcd #

**Forked from [cristifalcas/puppet-etcd](https://travis-ci.org/cristifalcas/puppet-etcd) to refactoring and improvement.**
- [x] improvement for CentOS 7 base usage
- [x] improvement for CentOS 7 cluster usage
- [] improvement for CentOS 7 cluster usage - SSL support
- [] improvement for CentOS 7 cluster usage - proxy support
- [] refactor code
- [] add new functions
- [x] hiera support

This module installs and configures etcd.

A basic provider is also implemented that can add/update/delete node keys

Because of the way etcd is working, you can't change any of the initial cluster variables after first run:

    initial_advertise_peer_urls
    initial_cluster
    initial_cluster_state
    initial_cluster_token

This is annoyng if you first bootstraped the cluster in http mode and you want to add ssl after that to initial_cluster parameter.

Solution:
* Don't care. Even if the protocol is http, the communication will be over ssl
* redeploy the cluster (rm -rf /var/lib/etcd/$data_dir)

# Latest version is compatible with: #
  * Puppet Enterprise 3.8.x, 3.7.x, 3.3.x, 3.2.x, 3.1.x
  * Puppet 3.x
  * RedHat, Debian
  * etcd 2.2.x

##Usage:

### Basic usage:

    include etcd

or

    class { 'etcd':
      ensure                     => 'latest',
      listen_client_urls    => 'http://0.0.0.0:2379',
    }

Add a key/value pair to etcd:

    etcd_key { '/coreos.com/network/config':
      value => '{ "Network": "10.1.0.0/16", "Backend": { "Type": "vxlan", "VNI": 1 }}',
    }

Remove a key:

    etcd_key { '/coreos.com/network1/config':
      ensure => absent
    }

### Deploy a cluster:

etcd1.domain.net

    class { 'etcd':
      ensure                      => 'latest',
      etcd_name                   => 'infra0',
      listen_client_urls          => 'http://0.0.0.0:2379',
      listen_peer_urls            => 'http://0.0.0.0:2380',
      initial_advertise_peer_urls => "http://${::fqdn}:2380",
      advertise_client_urls       => "http://${::fqdn}:2379",
      initial_cluster             => [
        "infra0=http://${::fqdn}:2380",
        'infra1=http://etcd2.domain.net:2380',
      ],
    }

etcd2.domain.net

    class { 'etcd':
      ensure                      => 'latest',
      etcd_name                   => 'infra1',
      listen_client_urls          => 'http://0.0.0.0:2379',
      listen_peer_urls            => 'http://0.0.0.0:2380',
      initial_advertise_peer_urls => "http://${::fqdn}:2380",
      advertise_client_urls       => "http://${::fqdn}:2379",
      initial_cluster             => [
        'infra0=http://etcd1.domain.net:2380',
        "infra1=http://${::fqdn}:2380",
      ],
    }

Test cluster(run on server):

    etcdctl cluster-health
    etcdctl member list

### Enable ssl for client communication:

    class { 'etcd':
      ensure                      => 'latest',
      etcd_name                   => $::hostname,
      listen_client_urls          => 'https://0.0.0.0:2379',
      advertise_client_urls       => "https://${::fqdn}:2379",
      # clients should speak over ssl
      cert_file                   => "${::settings::ssldir}/certs/${::clientcert}.pem",
      key_file                    => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
      # authorize clients
      client_cert_auth            => true,
      # and verify clients certificates
      trusted_ca_file             => "${::settings::ssldir}/certs/ca.pem",
      initial_cluster             => [
	      "${::hostname}=http://${::fqdn}:2380",
	      'infra1=http://infra1.domain.net:2380',
	      'infra2=http://infra2.domain.net:2380'],
    }

Use the etcd provider with ssl certificates:

    etcd_key { '/coreos.com/network/config':
      value     => '{ "Network": "10.1.0.0/18" }',
      peers     => "https://${::fqdn}:2379",
      cert_file => "${::settings::ssldir}/certs/${::clientcert}.pem",
      key_file  => "${::settings::ssldir}/private_keys/${::clientcert}.pem",
      # verify server ceretificate
      ca_file   => "${::settings::ssldir}/certs/ca.pem",
    }

### Deploy a cluster with full ssl for both clients and peers

    class { 'etcd':
      ensure                      => 'latest',
      etcd_name                   => $::hostname,
      # clients
      listen_client_urls          => 'https://0.0.0.0:2379',
      advertise_client_urls       => "https://${::fqdn}:2379",
      # clients ssl
      cert_file => '/etc/pki/puppet_certs/etcd/public_cert.pem',
      key_file  => '/etc/pki/puppet_certs/etcd/private_cert.pem',
      # authorize clients
      client_cert_auth            => true,
      # verify clients certificates
      trusted_ca_file             => '/etc/pki/puppet_certs/etcd/ca_cert.pem',
      # cluster
      listen_peer_urls            => 'https://0.0.0.0:2380',
      initial_advertise_peer_urls => "https://${::fqdn}:2380",
      initial_cluster             => [
	      "${::hostname}=http://${::fqdn}:2380",
	      'infra1=http://infra1.domain.net:2380',
	      'infra2=http://infra2.domain.net:2380'],
      # peers ssl
      peer_cert_file              => '/etc/pki/puppet_certs/etcd/public_cert.pem',
      peer_key_file               => '/etc/pki/puppet_certs/etcd/private_cert.pem',
      # authorize peers
      peer_client_cert_auth       => true,
      # verify peers certificates
      peer_trusted_ca_file        => '/etc/pki/puppet_certs/etcd/ca_cert.pem',
      debug     => true,
    }

### Deploy a proxy

If the $proxy parameter is undef, we will try to guess if the node should be a proxy by
checking if $::fqdn or $::ipaddress appears in initial_cluster parameter.

    class { 'etcd':
      ensure                      => 'latest',
      etcd_name                   => $::hostname,
      proxy                       => 'on',
      # clients
      listen_client_urls          => 'https://0.0.0.0:2379',
      advertise_client_urls       => "https://${::fqdn}:2379",
      # clients ssl
      cert_file => '/etc/pki/puppet_certs/etcd/public_cert.pem',
      key_file  => '/etc/pki/puppet_certs/etcd/private_cert.pem',
      # authorize clients
      client_cert_auth            => true,
      # verify clients certificates
      trusted_ca_file             => '/etc/pki/puppet_certs/etcd/ca_cert.pem',
      # cluster
      listen_peer_urls            => 'https://0.0.0.0:2380',
      initial_cluster             => [
	      'infra0=http://infra0.domain.net:2380',
	      'infra1=http://infra1.domain.net:2380',
	      'infra2=http://infra2.domain.net:2380'],
      # peers ssl
      peer_cert_file              => '/etc/pki/puppet_certs/etcd/public_cert.pem',
      peer_key_file               => '/etc/pki/puppet_certs/etcd/private_cert.pem',
      # authorize peers
      peer_client_cert_auth       => true,
      # verify peers certificates
      peer_trusted_ca_file        => '/etc/pki/puppet_certs/etcd/ca_cert.pem',
      debug     => true,
    }

### Hiera support

Hiera configuration example:

    etcd::etcd_packagename: 'etcd'
    etcd::ensure: 'present'
    etcd::etcd_name: 'infra0'
    etcd::service_ensure: 'running'
    etcd::listen_client_urls: 'http://0.0.0.0:2379'
    etcd::listen_peer_urls: 'http://0.0.0.0:2380'
    etcd::initial_advertise_peer_urls: "http://%{::fqdn}:2380"
    etcd::advertise_client_urls: "http://%{::fqdn}:2379"
    etcd::initial_cluster: ["infra0=http://%{::fqdn}:2380",'infra1=http://etcd2.domain.net:2380']
    etcd::data_dir: "/var/lib/etcd/infra0.etcd"
