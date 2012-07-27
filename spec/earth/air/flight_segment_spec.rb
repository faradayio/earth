require 'spec_helper'
require 'earth/air/flight_segment'
require 'factories/flight_segment'
require 'factories/airline'

describe FlightSegment do
  describe 'import', :data_miner => true do
    it 'should import data' do
      FlightSegment.run_data_miner!
    end
  end
  
  describe "verify imported data", :sanity => true, :flight_segment => true do
    before :all do
      FlightSegment.run_data_miner!
    end

    it "should have all the data" do
      FlightSegment.where(:year => 2009).count.should == 403_980
      FlightSegment.where(:year => 2010).count.should == 421_884
      FlightSegment.where(:year => 2011).count.should == 428_550
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

    it 'should relate to airline' do
      FlightSegment.any? { |fs| !fs.airline.nil? }.should be_true
    end
    
    it "should have aircraft description" do
      FlightSegment.where(:aircraft_description => nil).count.should == 0
    end
  end

  describe '#airline' do
    it 'finds an airline by BTS code' do
      FactoryGirl.create :airline, :delta
      FactoryGirl.create :airline, :united

      fs = FactoryGirl.build :flight_segment, :delta
      fs.airline.bts_code.should == 'DL'
    end
    it 'finds an airline by ICAO code' do
      FactoryGirl.create :airline, :delta
      FactoryGirl.create :airline, :united

      fs = FactoryGirl.build :flight_segment, :delta_icao
      fs.airline.bts_code.should == 'DL'
    end
    it 'returns nil if there is no airline' do
      fs = FactoryGirl.build :flight_segment
      fs.airline.should be_nil
    end
  end
end
