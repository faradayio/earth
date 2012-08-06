require 'spec_helper'
require 'earth/residence/air_conditioner_use'

describe AirConditionerUse do
  describe "Sanity check", :sanity => true do
    it { AirConditionerUse.count.should == 4 }
    
    # sanity check
    it { AirConditionerUse.find('Turned on quite a bit').fugitive_emission.should be_within(5e-6).of(0.5757) }
    
    describe '.fallback' do
      let(:fallback) { AirConditionerUse.fallback }
      it { fallback.fugitive_emission.should be_within(5e-6).of(0.49945) }
      it { fallback.fugitive_emission_units.should == 'kilograms_per_square_metre' }
    end
  end
end
