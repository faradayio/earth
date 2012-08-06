require 'spec_helper'
require "#{Earth::FACTORY_DIR}/residence_appliance"

describe ResidenceAppliance do
  describe '.annual_energy_from_electricity_for(appliance_plural)' do
    it "should return the appliance's annual energy from electricity" do
      FactoryGirl.create :residence_appliance, :fridge
      ResidenceAppliance.annual_energy_from_electricity_for('fridges').should == 1000
      ResidenceAppliance.annual_energy_from_electricity_for('computers').should be_nil
    end
  end
  
  describe "Sanity check", :sanity => true do
    it { ResidenceAppliance.count.should == 2 }
    
    # spot check
    it { ResidenceAppliance.first.annual_energy_from_electricity.should == 1754840000 }
  end
end
