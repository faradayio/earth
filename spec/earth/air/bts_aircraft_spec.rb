require 'spec_helper'
require 'earth/air/bts_aircraft'

describe BtsAircraft do
  describe 'import', :data_miner => true do
    before do
      Earth.init :air, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'should import data' do
      BtsAircraft.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      BtsAircraft.count.should == 379
    end
  end
end
