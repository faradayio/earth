require 'spec_helper'
require 'earth/rail/rail_fuel'

describe RailFuel do
  describe 'Sanity check', :sanity => true do
    it { RailFuel.count.should == 1 }
    
    # spot check
    let(:diesel) { RailFuel.find 'diesel' }
    it { diesel.ch4_emission_factor.should be_within(5e-6).of(0.00529) }
    it { diesel.n2o_emission_factor.should be_within(5e-6).of(0.02016) }
    
    let(:distillate) { Fuel.find 'Distillate Fuel Oil No. 2' }
    it { diesel.fuel.should == distillate }
    it { diesel.density.should == distillate.density }
    it { diesel.co2_emission_factor.should == distillate.co2_emission_factor }
    it { diesel.co2_biogenic_emission_factor.should == distillate.co2_biogenic_emission_factor }
  end
end
