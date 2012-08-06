require 'spec_helper'
require 'earth/electricity/electric_market'

describe ElectricMarket do
  describe 'Sanity check', :sanity => true do
    it { ElectricMarket.count.should == 64864 }
    it { ElectricMarket.where(:electric_utility_eia_id => nil).count.should == 0 }
    
    # spot check
    it 'links 53704 to MG&E' do
      ElectricMarket.where(:electric_utility_eia_id => 11479).map(&:zip_code_name).should include('53704')
    end
  end
end
