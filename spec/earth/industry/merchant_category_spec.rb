require 'spec_helper'
require 'earth/industry/merchant_category'

describe MerchantCategory do
  describe 'verify data', :sanity => true do
    it 'should import valid data' do
      MerchantCategory.count.should > 0
      MerchantCategory.first.mcc.to_s.should =~ /^\d+$/
      MerchantCategory.first.description.to_s.should_not be_empty
    end
  end
end
