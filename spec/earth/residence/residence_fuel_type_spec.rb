require 'spec_helper'
require 'earth/residence/residence_fuel_type'

describe ResidenceFuelType do
  describe '.[](fuel)' do
    it "finds a fuel by name" do
      oil = ResidenceFuelType.find_or_create_by_name('fuel oil')
      ResidenceFuelType['Fuel Oil'].should == oil
    end
  end
  
  describe "Sanity check", :sanity => true do
    it { ResidenceFuelType.count.should == 7 }
    
    # spot check
    it { ResidenceFuelType.find('fuel oil').emission_factor.should be_within(5e-6).of(2.69729) }
  end
end
