require 'spec_helper'
require 'earth/hospitality/commercial_building_energy_consumption_survey_response'

describe CommercialBuildingEnergyConsumptionSurveyResponse do
  before :all do
    CommercialBuildingEnergyConsumptionSurveyResponse.auto_upgrade!
  end
  
  describe "when importing data", :data_miner => true do
    before do
      require 'earth/hospitality/commercial_building_energy_consumption_survey_response/data_miner'
    end
    
    it "imports all naics codes" do
      CommercialBuildingEnergyConsumptionSurveyResponse.run_data_miner!
      CommercialBuildingEnergyConsumptionSurveyResponse.count.should == 5215
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "should have room nights and fuel intensities per room night for lodging_records" do
      spot_check = CommercialBuildingEnergyConsumptionSurveyResponse.lodging_records.first
      spot_check.room_nights.should == 6205
      spot_check.natural_gas_per_room_night.should be_within(0.00001).of(1.62234)
      spot_check.natural_gas_per_room_night_units.should == 'cubic_metres_per_room_night'
    end
  end
  
  describe ".lodging_records" do
    it "should return only records representing Hotels, Motels, and Inns with no other activity" do
      lodging_records = CommercialBuildingEnergyConsumptionSurveyResponse.lodging_records
      lodging_records.map(&:detailed_activity).uniq.sort.should == ['Hotel', 'Motel or inn']
      lodging_records.map(&:first_activity).uniq.should == [nil]
      lodging_records.count.should == 192
    end
  end
end
