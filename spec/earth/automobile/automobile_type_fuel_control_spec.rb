require 'spec_helper'
require 'earth/automobile/automobile_type_fuel_control'

describe AutomobileTypeFuelControl do
  before :all do
    require 'earth/acronyms'
  end
  
  describe 'verify imported data', :sanity => true do
    it { ATFC.count.should == 20 }
    it { ATFC.where("ch4_emission_factor > 0").count.should == ATFC.count }
    it { ATFC.where("n2o_emission_factor > 0").count.should == ATFC.count }
    
    # spot checks
    it { ATFC.first.ch4_emission_factor.should be_within(1e-9).of(1.5534e-5) }
    it { ATFC.first.n2o_emission_factor.should be_within(1e-8).of(2.7775e-4) }
  end
end
