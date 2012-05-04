require 'spec_helper'
require 'earth/bus/bus_fuel'

describe 'BusFuel' do
  describe 'import', :data_miner => true do
    before do
      Earth.init :locality, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'loads data' do
      BusFuel.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      BusFuel.count.should == 7
    end
    it 'is related to fuels' do
      BusFuel.last.fuel.should_not be_nil
    end
  end
end
