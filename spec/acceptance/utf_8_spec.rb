require 'spec_helper_acceptance'

describe 'utf_8 class' do
  context 'users and groups' do
    let(:manifest) {
      <<-EOS
        class { 'utf_8':
          ensure_users => true,
          user_array   => ['ブレット','Rößle'],
        }
      EOS
    }

    it 'Should bloody work' do
      apply_manifest(manifest, :catch_failures => true)
    end

    describe user('Rößle') do
      it { is_expected.to exist}
      it { is_expected.to belong_to_group 'Rößle' }
    end
  end
end
