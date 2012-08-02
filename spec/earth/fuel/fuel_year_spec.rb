require 'spec_helper'
require 'earth/fuel/fuel_year'

describe FuelYear do
  describe 'Sanity check', :sanity => true do
    let(:total) { FuelYear.count }
    
    it { total.should == 171 }
    it { FuelYear.where("carbon_content > 0").count.should == total }
    it { FuelYear.where("energy_content > 0").count.should == total }
    it { FuelYear.where("co2_emission_factor > 0").count.should == total }
    it { FuelYear.where("co2_biogenic_emission_factor >= 0").count.should == total }
    
    # Spot check
    let(:gas) { FuelYear.find('Motor Gasoline 2008') }
    it { gas.carbon_content.should be_within(5e-5).of(18.4445) }
    it { gas.energy_content.should be_within(5e-5).of(34.6272) }
    it { gas.co2_emission_factor.should be_within(5e-6).of(2.34183) }
    it { gas.co2_biogenic_emission_factor.should be_within(5e-6).of(0) }
  end
end
