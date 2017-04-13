require 'rspec-puppet/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'beaker-rspec/rake_task'

PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "vendor/**/*.pp"]
task default: [:spec, :rspec, :lint]
