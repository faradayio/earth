require 'spec_helper'
require 'earth/hospitality/commercial_building_energy_consumption_survey_response'

describe CommercialBuildingEnergyConsumptionSurveyResponse do
  let(:cbecs) { CommercialBuildingEnergyConsumptionSurveyResponse }
  
  describe "when importing data", :data_miner => true do
    before do
      Earth.init :hospitality, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it "imports all naics codes" do
      cbecs.run_data_miner!
    end
  end
  
  describe "verify imported data", :sanity => true do
    let(:total) { cbecs.count }
    let(:first) { cbecs.lodging_records.first }
    
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
      first.room_nights.should == 6205
      first.natural_gas_energy.should be_within(0.5).of(386700)
      first.natural_gas_per_room_night.should be_within(5e-4).of(111.056)
    end
  end
  
  describe ".lodging_records" do
    it "should return records representing Hotels, Motels, and Inns with no other activity" do
      cbecs.lodging_records.map(&:detailed_activity).uniq.sort.should == ['Hotel', 'Motel or inn']
      cbecs.lodging_records.map(&:first_activity).uniq.should == [nil]
      cbecs.lodging_records.count.should == 192
    end
  end
end
