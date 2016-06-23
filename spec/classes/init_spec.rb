require 'spec_helper'
describe 'japan' do

  context 'all defaults' do

    it {
      should contain_notify('こんにちは')
    }
  end
end
