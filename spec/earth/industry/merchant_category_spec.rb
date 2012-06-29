require 'spec_helper'
require 'earth/industry/merchant_category'

describe MerchantCategory do
  describe 'import', :data_miner => true do
    before do
      Earth.init :industry, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'should import data' do
      MerchantCategory.run_data_miner!
      MerchantCategory.count.should > 0
      MerchantCategory.first.mcc.to_s.should =~ /^\d+$/
      MerchantCategory.first.description.to_s.should_not be_empty
    end
  end
end
