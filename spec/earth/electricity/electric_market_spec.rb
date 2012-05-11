require 'spec_helper'
require 'earth/electricity/electric_market'
require 'earth/electricity/electric_utility' # needed for test verifying link with ElectricUtility

describe ElectricMarket do
  describe 'import', :data_miner => true do
    before :all do
      Earth.init :electricity, :load_data_miner => true, :skip_parent_associations => true
    end
    
    it 'should import data' do
      ElectricMarket.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it { ElectricMarket.count.should == 64864 }
    
    it { ElectricMarket.where(:electric_utility_eia_id => nil).count.should == 0 } # some ids aren't found in our electric_utilities table
    
    it 'Properly links 53704 to MG&E' do
      ZipCode.find('53704').electric_utilities.should include(ElectricUtility.find 11479)
    end
  end
end
