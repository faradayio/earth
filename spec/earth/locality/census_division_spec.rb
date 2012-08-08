require 'spec_helper'
require 'earth/locality/census_division'

describe CensusDivision do
  describe 'Sanity check', :sanity => true do
    it { CensusDivision.count.should == 9 }
    
    # spot check
    let(:pacific) { CensusDivision.find 9 }
    it { pacific.meeting_building_natural_gas_intensity.should be_within(5e-6).of(0.00179) }
    it { pacific.meeting_building_fuel_oil_intensity.should be_within(5e-10).of(0.000000012) }
    it { pacific.meeting_building_electricity_intensity.should be_within(5e-6).of(0.04644) }
    it { pacific.meeting_building_district_heat_intensity.should be_within(5e-6).of(0) }
    
    describe '.fallback' do
      let(:fallback) { CensusDivision.fallback }
      
      it { fallback.name.should == 'fallback' }
      it { fallback.meeting_building_natural_gas_intensity.should be_within(5e-6).of(0.01327) }
      it { fallback.meeting_building_fuel_oil_intensity.should be_within(5e-6).of(0.00377) }
      it { fallback.meeting_building_electricity_intensity.should be_within(5e-6).of(0.09077) }
      it { fallback.meeting_building_district_heat_intensity.should be_within(5e-6).of(0.00542) }
    end
  end
end
