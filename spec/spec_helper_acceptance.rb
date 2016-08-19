require 'beaker-rspec'

UNSUPPORTED_PLATFORMS = [ 'Solaris', 'AIX' ]

unless ENV['RS_PROVISION'] == 'no' or ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    install_puppet_agent_on(host, :version => '1.5.2')
    on hosts, "mkdir -p #{host['distmoduledir']}"
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|
      install_dev_puppet_module_on(host,:source => proj_root, :module_name => 'utf_8', :target_module_path => '/etc/puppetlabs/code/modules')
      # Required for binding tests.
      if fact("os['family']") == 'windows'
        shell('puppet module install puppetlabs-acl --version 1.1.2', { :acceptable_exit_codes => [0,1] })
        shell('puppet module install puppetlabs-registry --version 1.1.3', { :acceptable_exit_codes => [0,1] })
      end

      shell('puppet module install puppetlabs-stdlib --version 4.12.0', { :acceptable_exit_codes => [0,1] })
      shell('puppet module install puppetlabs-concat --version 2.2.0', { :acceptable_exit_codes => [0,1] })
    end
  end
end
