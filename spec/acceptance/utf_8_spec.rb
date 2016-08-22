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

    describe user('ブレット') do
      it { is_expected.to exist}
      it { is_expected.to belong_to_primary_group 'ブレット_grp' }
    end

    if fact("kernel") == 'Linux'
      describe file('/home/ブレット') do
        it { is_expected.to exist}
        it { is_expected.to be_directory}
        it { is_expected.to be_owned_by 'ブレット'}
      end
    elsif fact('kernel') == 'windows'
      describe file('C:\\Users\\ブレット') do
        it { is_expected.to exist}
        it { is_expected.to be_directory}
        it { is_expected.to be_owned_by 'ブレット'}
      end
    end

    describe user('Rößle') do
      it { is_expected.to exist}
      it { is_expected.to belong_to_primary_group 'Rößle_grp' }
    end

    if fact("kernel") == 'Linux'
      describe file('/home/Rößle') do
        it { is_expected.to exist}
        it { is_expected.to be_directory}
        it { is_expected.to be_owned_by 'Rößle'}
      end
    end

    describe group('オージー') do
      it { is_expected.to exist}
    end

    describe group('ブレット_grp') do
      it { is_expected.to exist}
    end

    describe group('Rößle_grp') do
      it { is_expected.to exist}
    end
  end
end
