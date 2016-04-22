require 'spec_helper'

describe 'etcd', :type => :class do
  describe 'On an unknown OS' do
    let(:facts) { {:osfamily => 'Unknown'} }
    it { should raise_error() }
  end

  describe 'On a Debian OS' do
    let(:facts) { {
        :osfamily => 'Debian',
        :fqdn     => 'etcd.test.local'
      } }

    context 'When overriding service parameters' do
      let(:params) { {
          :service_ensure => 'stopped',
          :service_enable => false
        } }
      it { should contain_service('etcd').with_ensure('stopped').with_enable('false') }
    end

    context 'When specifying a custom discovery endpoint and token' do
      let(:params) { {
          :discovery          => true,
          :discovery_endpoint => 'http://local-discovery:4001/v2/keys/',
          :discovery_token    => '123456'
        } }
      it {
        should contain_file('/etc/etcd/etcd.conf').with_content(/discovery\s*= "http:\/\/local-discovery:4001\/v2\/keys\/123456"/)
      }
    end

    context 'When enabling cluster discovery without a token' do
      let(:params) { { :discovery => true } }
      it {
        should raise_error()
      }
    end
  end

  describe 'On a Redhat OS' do
    let(:facts) { {
        :osfamily => 'Redhat',
        :fqdn     => 'etcd.test.local'
      } }

    context 'When overriding service parameters' do
      let(:params) { {
          :service_ensure => 'stopped',
          :service_enable => false }}
      it { should contain_service('etcd').with_ensure('stopped').with_enable('false') }
    end

end