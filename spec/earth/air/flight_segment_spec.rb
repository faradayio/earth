require 'spec_helper'
require 'earth/air/flight_segment'

describe FlightSegment do
  describe 'import', :data_miner => true do
    before do
      Earth.init :air, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'should import data' do
      FlightSegment.run_data_miner!
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "should have all the data" do
      FlightSegment.where(:year => 2009).count.should == 403_959
      FlightSegment.where(:year => 2010).count.should == 421_725
      FlightSegment.where(:year => 2011).count.should >= 357_688
    end
    
    it "should have year from 2009 to present" do
      FlightSegment.where("NOT(year >= 2009 AND year <= #{::Time.now.year})").count.should == 0
    end
    
    it "should have data through 7 months ago" do
      if (today = Date.today).day < 23
        latest = today << 7
      else
        latest = today << 6
      end
      FlightSegment.maximum(:year).should == latest.year
      FlightSegment.where(:year => latest.year).maximum(:month).should == latest.month
    end
    
    it "should have origin airport in airports" do
      FlightSegment.connection.select_values("SELECT DISTINCT origin_airport_iata_code FROM flight_segments").each do |code|
        Airport.exists?(:iata_code => code).should == true
      end
    end
    
    it "should have destination airport in airports" do
      FlightSegment.connection.select_values("SELECT DISTINCT destination_airport_iata_code FROM flight_segments").each do |code|
        Airport.exists?(:iata_code => code).should == true
      end
    end
    
    it "should have origin country iso code in countries" do
      FlightSegment.connection.select_values("SELECT DISTINCT origin_country_iso_3166_code FROM flight_segments").each do |code|
        Country.exists?(:iso_3166_code => code).should == true
      end
    end
    
    it "should have destination country iso code in countries" do
      FlightSegment.connection.select_values("SELECT DISTINCT destination_country_iso_3166_code FROM flight_segments").each do |code|
        Country.exists?(:iso_3166_code => code).should == true
      end
    end
    
    it "should have airline name in airlines" do
      FlightSegment.connection.select_values("SELECT DISTINCT airline_name FROM flight_segments").each do |name|
        Airline.exists?(:name => name).should == true
      end
    end
    
    it "should have aircraft description" do
      FlightSegment.where(:aircraft_description => nil).count.should == 0
    end
  end
end
