require 'spec_helper'
require 'earth/bus/bus_fuel_control'

describe 'BusFuelControl' do
  describe 'import', :data_miner => true do
    before do
      Earth.init :bus, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'imports successfully' do
      BusFuelControl.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      BusFuelControl.count.should == 9
    end
  end
end
