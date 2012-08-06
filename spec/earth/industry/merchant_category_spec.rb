require 'spec_helper'
require 'earth/industry/merchant_category'

describe MerchantCategory do
  describe '#name' do
    it "returns the description" do
      MerchantCategory.new(:description => 'Description').name.should == 'Description'
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { MerchantCategory.count.should == 285 }
  end
end
