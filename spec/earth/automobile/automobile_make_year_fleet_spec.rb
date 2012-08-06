require 'spec_helper'
require 'earth/automobile/automobile_make_year_fleet'

describe AutomobileMakeYearFleet do
  let(:amyf) { AutomobileMakeYearFleet }
  
  describe 'Sanity check', :sanity => true do
    let(:total) { amyf.count }
    
    it { total.should == 1349 }
    it { amyf.where('year >= 1978 AND year <= 2011').count.should == total }
    it { amyf.where('volume > 0').count.should == total }
    it { amyf.where('fuel_efficiency > 0').count.should == total }
    it { amyf.where(:fuel_efficiency_units => 'kilometres_per_litre').count.should == total }
  end
end
