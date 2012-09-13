require 'spec_helper'
require "#{Earth::FACTORY_DIR}/airline"
require "#{Earth::FACTORY_DIR}/flight_segment"
require 'earth/air/airport'

describe FlightSegment do
  describe '#airline' do
    it 'finds an airline by BTS code' do
      FactoryGirl.create :airline, :delta
      FactoryGirl.create :airline, :united
      
      fs = FactoryGirl.build(:flight_segment, :delta)
      fs.airline.bts_code.should == 'DL'
    end
    it 'finds an airline by ICAO code' do
      FactoryGirl.create :airline, :delta
      FactoryGirl.create :airline, :united
      
      fs = FactoryGirl.build :flight_segment, :delta_icao
      fs.airline.bts_code.should == 'DL'
    end
    it 'returns nil if there is no airline' do
      Airline.delete_all
      
      fs = FactoryGirl.build :flight_segment
      fs.airline.should be_nil
    end
  end
  
  describe "Santy check", :sanity => true, :slow => true do
    it "should have all the data" do
      FlightSegment.where(:year => 2009).count.should == 403_980
      FlightSegment.where(:year => 2010).count.should == 421_884
      FlightSegment.where(:year => 2011).count.should == 428_554
      FlightSegment.where(:year => 2012).count.should >   67_168
    end
    
    it "should have year from 2009 through 7 months ago" do
      FlightSegment.where("NOT(year >= 2009 AND year <= #{::Time.now.year})").count.should == 0
      if (today = Date.today).day < 23
        latest = today << 7
      else
        latest = today << 6
      end
      FlightSegment.maximum(:year).should == latest.year
      FlightSegment.where(:year => latest.year).maximum(:month).should == latest.month
    end
    
    it "should have origin and destination airport in airports" do
      %w{ origin destination }.each do |attribute|
        missing = []
        FlightSegment.connection.select_values("SELECT DISTINCT #{attribute}_airport_iata_code FROM flight_segments").each do |code|
          missing << code unless Airport.exists?(:iata_code => code)
        end
        raise "Could not find the following #{attribute} airports:\n#{missing}" if missing.any?
      end
    end
    
    it "should have origin and destination country in countries" do
      %w{ origin destination }.each do |attribute|
        missing = []
        FlightSegment.connection.select_values("SELECT DISTINCT #{attribute}_country_iso_3166_code FROM flight_segments").each do |code|
          missing << code unless Country.exists?(:iso_3166_code => code)
        end
        raise "Could not find the following #{attribute} countries:\n#{missing}" if missing.any?
      end
    end
    
    it "should have airline name in airlines" do
      missing = []
      FlightSegment.connection.select_values("SELECT DISTINCT airline_name FROM flight_segments").each do |name|
        missing << name unless Airline.exists?(:name => name)
      end
      raise "Could not find the following airlines:\n#{missing}" if missing.any?
    end
    
    it "should have aircraft description" do
      FlightSegment.where(:aircraft_description => nil).count.should == 0
    end
    
    describe '.fallback' do
      let(:fallback) { FlightSegment.fallback }
      
      it { fallback.distance.should be_within(0.5).of(2135) }
      it { fallback.seats_per_flight.should be_within(0.5).of(146) }
      it { fallback.load_factor.should be_within(5e-3).of(0.8) }
      it { fallback.freight_share.should be_within(5e-3).of(0.04) }
    end
  end
end
