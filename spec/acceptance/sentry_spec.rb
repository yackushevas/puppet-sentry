require 'spec_helper_acceptance'

PUPPET_RUN_UNCHANGED = 0
PUPPET_RUN_FAILED    = 1
PUPPET_RUN_CHANGED   = 2

describe 'sentry class' do
  let(:manifest) {
    <<-EOS
      package { ['yum-utils', 'scl-utils', 'scl-utils-build', 'centos-release-scl']:
        ensure => present;
      }

      class { 'sentry' :
      }
    EOS
  }

  it 'should run without errors' do
    result = apply_manifest(manifest, catch_failures: true)
    expect(@result.exit_code).to eq PUPPET_RUN_CHANGED
  end

  it 'should run again without errors' do
    result = apply_manifest(manifest, catch_failures: true)
    expect(@result.exit_code).to eq PUPPET_RUN_UNCHANGED
  end
end
