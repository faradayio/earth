require 'spec_helper'
require 'earth/automobile/automobile_make_year_fleet'

describe AutomobileMakeYearFleet do
  describe 'import', :data_miner => true do
    before do
      Earth.init :automobile, :load_data_miner => true
      require 'earth/acronyms'
    end
    
    it 'should import data' do
      AMYF.run_data_miner!
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it { AMYF.count.should == 1349 }
    it { AMYF.where('year >= 1978 AND year <= 2011').count.should == AMYF.count }
    it { AMYF.where('volume > 0').count.should == AMYF.count }
    it { AMYF.where('fuel_efficiency > 0').count.should == AMYF.count }
    it { AMYF.where(:fuel_efficiency_units => 'kilometres_per_litre').count.should == AMYF.count }
  end
end
