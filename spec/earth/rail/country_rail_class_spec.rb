require 'spec_helper'
require 'earth/rail/country_rail_class'

describe CountryRailClass do
  describe 'Sanity check', :sanity => true do
    it { CountryRailClass.count.should == 4 }
    
    # spot check
    let(:us_heavy) { CountryRailClass.find 'US heavy' }
    it { us_heavy.speed.should be_within(5e-3).of(32.7) }
    it { us_heavy.trip_distance.should be_within(5e-3).of(7.7) }
    it { us_heavy.electricity_intensity.should be_within(5e-5).of(0.1585) }
    it { us_heavy.diesel_intensity.should be_within(5e-5).of(0) }
    it { us_heavy.co2_emission_factor.should be_within(5e-5).of(0.1024) }
  end
end
