require 'spec_helper'
describe 'japan' do

  context 'all defaults' do
    let(:facts) {
      {
        'kernel' => 'Linux',
      }
    }

    it {
      should contain_notify('こんにちは')
    }
  end
end
