require 'spec_helper'
require 'earth/rail/country_rail_traction_class'

describe CountryRailTractionClass do
  describe 'Sanity check', :sanity => true do
    it { CountryRailTractionClass.count.should == 125 }
    
    # spot check
    let(:gb_elec_highspeed) { CountryRailTractionClass.find 'GB electric highspeed' }
    it { gb_elec_highspeed.electricity_intensity.should be_within(5e-5).of(0.07) }
    it { gb_elec_highspeed.diesel_intensity.should be_within(5e-6).of(0) }
    it { gb_elec_highspeed.co2_emission_factor.should be_within(5e-6).of(0.04153) }
  end
end
