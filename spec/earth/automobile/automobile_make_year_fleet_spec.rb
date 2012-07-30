require 'spec_helper'
require 'earth/automobile/automobile_make_year_fleet'

describe AutomobileMakeYearFleet do
  describe 'verify imported data', :sanity => true do
    it { AMYF.count.should == 1349 }
    it { AMYF.where('year >= 1978 AND year <= 2011').count.should == AMYF.count }
    it { AMYF.where('volume > 0').count.should == AMYF.count }
    it { AMYF.where('fuel_efficiency > 0').count.should == AMYF.count }
    it { AMYF.where(:fuel_efficiency_units => 'kilometres_per_litre').count.should == AMYF.count }
  end
end
