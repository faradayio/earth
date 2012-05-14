require 'spec_helper'
require 'earth/automobile/automobile_make_year_fleet'

describe AutomobileMakeYearFleet do
  describe 'import', :data_miner => true do
    before do
      Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'should import data' do
      AutomobileMakeYearFleet.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      AutomobileMakeYearFleet.count.should == 1349
    end
    
    it 'should have year from 1978 to 2011' do
      AutomobileMakeYearFleet.where('year IS NULL OR year < 1978 OR year > 2011').count.should == 0
    end
    
    it 'should have volume greater than zero' do
      AutomobileMakeYearFleet.where('volume IS NULL OR volume <= 0').count.should == 0
    end
    
    it 'should have fuel efficiency greater than zero' do
      AutomobileMakeYearFleet.where('fuel_efficiency IS NULL OR fuel_efficiency <= 0').count.should == 0
    end
    
    it 'should have fuel efficiency units of kilometres per litre' do
      AutomobileMakeYearFleet.where("fuel_efficiency_units IS NULL OR fuel_efficiency_units != 'kilometres_per_litre'").count.should == 0
    end
  end
end
