require 'spec_helper_acceptance'

describe 'sentry class' do
  let(:manifest) {
    <<-EOS
        class { 'python' :
          version    => 'system',
          pip        => 'present',
          dev        => 'present',
          virtualenv => 'present',
        }
      class { 'sentry': }
    EOS
  }

  it 'runs without errors' do
    apply_manifest(manifest, catch_failures: true)
  end

  it 'is idempotent' do
    apply_manifest(manifest, catch_changes: true)
  end
end
