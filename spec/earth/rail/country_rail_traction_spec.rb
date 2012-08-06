require 'spec_helper'
require 'earth/rail/country_rail_traction'

describe CountryRailTraction do
  describe 'Sanity check', :sanity => true do
    it { CountryRailTraction.count.should == 50 }
    
    # spot check
    let(:gb_diesel) { CountryRailTraction.find 'GB diesel' }
    it { gb_diesel.electricity_intensity.should be_within(5e-5).of(0) }
    it { gb_diesel.diesel_intensity.should be_within(5e-6).of(0.02802) }
    it { gb_diesel.co2_emission_factor.should be_within(5e-6).of(0.08351) }
  end
end
