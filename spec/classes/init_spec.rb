require 'spec_helper'
describe 'odoo' do

  context 'with defaults for all parameters' do
    it { should contain_class('odoo') }
  end
end
