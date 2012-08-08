require 'spec_helper'
require 'earth/automobile/automobile_type_fuel_control'

describe AutomobileTypeFuelControl do
  let(:atfc) { AutomobileTypeFuelControl }
  
  describe 'Sanity check', :sanity => true do
    let(:total) { atfc.count }
    
    it { total.should == 20 }
    it { atfc.where("ch4_emission_factor > 0").count.should == total }
    it { atfc.where("n2o_emission_factor > 0").count.should == total }
    
    # spot checks
    it { atfc.first.ch4_emission_factor.should be_within(1e-9).of(1.5534e-5) }
    it { atfc.first.n2o_emission_factor.should be_within(1e-8).of(2.7775e-4) }
  end
end
