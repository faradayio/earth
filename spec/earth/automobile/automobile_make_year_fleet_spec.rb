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
    it { AutomobileMakeYearFleet.count.should == 1349 }
    it { AutomobileMakeYearFleet.where('year >= 1978 AND year <= 2011').count.should == AutomobileMakeYearFleet.count }
    it { AutomobileMakeYearFleet.where('volume > 0').count.should == AutomobileMakeYearFleet.count }
    it { AutomobileMakeYearFleet.where('fuel_efficiency > 0').count.should == AutomobileMakeYearFleet.count }
    it { AutomobileMakeYearFleet.where(:fuel_efficiency_units => 'kilometres_per_litre').count.should == AutomobileMakeYearFleet.count }
  end
end
