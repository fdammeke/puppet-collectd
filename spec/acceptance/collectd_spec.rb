require 'spec_helper_acceptance'

describe 'collectd' do
  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        include yum
        include stdlib
        include stdlib::stages
        include profile::package_management

        class { 'cegekarepos' : stage => 'setup_repo' }
        Yum::Repo <| title == 'cegeka-unsigned' |>
        Yum::Repo <| title == 'cegeka-custom' |>
        Yum::Repo <| title == 'cegeka-custom-noarch' |>

        collectd::instance { 'default':
          version  => '5.2.2-3.cgk.el6',
          interval => '30'
        }

        collectd::instance::config::tcpconns { 'default':
          tcp_connections_items => [
            {
              'listening_ports' => 'false',
              'local_port'      => '31337'
            }
          ]
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
    describe process("collectd") do
      it { should be_running }
    end

    describe file('/etc/collectd.d/tcpconns/init.conf') do
      it { should contain '31337' }
    end
  end
end
