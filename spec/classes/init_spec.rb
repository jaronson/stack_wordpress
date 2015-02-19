require 'spec_helper'
describe 'stack_wordpress' do

  context 'with defaults for all parameters' do
    it { should contain_class('stack_wordpress') }
  end
end
