require 'spec_helper'
require 'earth/hospitality/country_lodging_class'

describe CountryLodgingClass do
  describe "when importing data", :data_miner => true do
    before do
      Earth.init :hospitality, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it "imports all naics codes" do
      CountryLodgingClass.run_data_miner!
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "should have all the data" do
      CountryLodgingClass.count.should == 3
    end
    
    it "should have fuel intensities" do
      us_hotel = CountryLodgingClass.find 'US Hotel'
      us_hotel.fuel_oil_intensity.should be_within(0.00001).of(0.25014)
      us_hotel.fuel_oil_intensity_units.should == 'litres_per_occupied_room_night'
    end
    
    it "should have the correct total weighting for the US" do
      CountryLodgingClass.where(:country_iso_3166_code => 'US').sum(&:weighting).should == be_within(0.1).of(89209.2)
    end
  end
end
