require 'spec_helper'
require 'earth/bus/bus_fuel_year_control'

describe 'BusFuelYearControl' do
  describe 'import', :data_miner => true do
    before do
      Earth.init :bus, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'imports successfully' do
      BusFuelYearControl.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      BusFuelYearControl.all.count.should == 67
    end
    it 'is related to BusFuelControl' do
      BusFuelYearControl.first.control.should_not be_nil
    end
  end
end
