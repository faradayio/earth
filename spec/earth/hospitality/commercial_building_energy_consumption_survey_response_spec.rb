require 'spec_helper'
require "#{Earth::FACTORY_DIR}/commercial_building_energy_consumption_survey_response"

describe CommercialBuildingEnergyConsumptionSurveyResponse do
  let(:cbecs) { CommercialBuildingEnergyConsumptionSurveyResponse }
  
  describe ".lodging_records" do
    it "should return records representing Hotels, Motels, and Inns with no other activity" do
      cbecs.delete_all
      h = FactoryGirl.create :cbecs_response, :hotel
      m = FactoryGirl.create :cbecs_response, :motel
      FactoryGirl.create :cbecs_response, :warehouse
      FactoryGirl.create :cbecs_response, :hotel_warehouse
      cbecs.lodging_records.should == [h, m]
    end
  end
  
  describe "Sanity check", :sanity => true do
    let(:total) { cbecs.count }
    let(:first_lodging) { cbecs.lodging_records.first }
    
    it { total.should == 5215 }
    it { cbecs.where("electricity_use >= 0").count.should == total }
    it { cbecs.where("electricity_energy >= 0").count.should == total }
    it { cbecs.where("natural_gas_use >= 0").count.should == total }
    it { cbecs.where("natural_gas_energy >= 0").count.should == total }
    it { cbecs.where("fuel_oil_use >= 0").count.should == total }
    it { cbecs.where("fuel_oil_energy >= 0").count.should == total }
    it { cbecs.where("district_heat_use >= 0").count.should == total }
    it { cbecs.where("district_heat_energy >= 0").count.should == total }
    
    # spot check
    it "should have room nights and fuel intensities per room night for lodging_records" do
      first_lodging.room_nights.should == 6205
      
      first_lodging.electricity_energy.should be_within(0.5).of(221809)
      first_lodging.electricity_per_room_night.should be_within(5e-4).of(37.711)
      first_lodging.electricity_per_room_night_units.should == 'megajoules_per_room_night'
      
      first_lodging.natural_gas_energy.should be_within(0.5).of(386700)
      first_lodging.natural_gas_per_room_night.should be_within(5e-4).of(79.343)
      first_lodging.natural_gas_per_room_night_units.should == 'megajoules_per_room_night'
      
      first_lodging.fuel_oil_energy.should be_within(5e-4).of(0)
      first_lodging.fuel_oil_per_room_night.should be_within(5e-4).of(12.97)
      first_lodging.fuel_oil_per_room_night_units.should == 'megajoules_per_room_night'
    end
  end
end
