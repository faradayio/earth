require 'spec_helper'
require 'earth/hospitality/country_lodging_class'

describe CountryLodgingClass do
  before :all do
    CountryLodgingClass.auto_upgrade!
  end
  
  describe "when importing data", :slow => true do
    before do
      require 'earth/hospitality/country_lodging_class/data_miner'
    end
    
    it "imports all naics codes" do
      CountryLodgingClass.run_data_miner!
      CountryLodgingClass.count.should == 3
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "should have fuel intensities" do
      us_hotel = CountryLodgingClass.find 'US Hotel'
      us_hotel.fuel_oil_intensity.should be_within(0.00001).of(0.25014)
      us_hotel.fuel_oil_intensity_units.should == 'litres_per_occupied_room_night'
    end
    
    it "should have the correct total weighting for the US" do
      CountryLodgingClass.where(:country_iso_3166_code => 'US').sum(&:weighting).should == be_within(0.0001).of(89209.27734)
    end
  end
end
