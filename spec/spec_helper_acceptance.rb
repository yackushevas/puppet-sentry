#require 'beaker-rspec/spec_helper'
#require 'beaker-rspec/helpers/serverspec'
require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

require 'pry'

run_puppet_install_helper
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|

  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    hosts.each do |host|
      puppet_module_install(source: module_root, module_name: 'sentry')
      on(host, puppet('module', 'install', 'puppetlabs-stdlib'))
    end
  end
end
