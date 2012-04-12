require 'spec_helper'
require 'earth/air/flight_segment'

describe FlightSegment do
  before :all do
    FlightSegment.auto_upgrade!
  end
  
  describe 'import', :data_miner => true do
    before do
      require 'earth/air/flight_segment/data_miner'
    end
    
    it 'should import data' do
      FlightSegment.run_data_miner!
      FlightSegment.all.count.should == 1_149_003
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "should have year from 2009 to present" do
      FlightSegment.where("year IS NULL OR year < 2009 OR year > #{::Time.now.year}").count.should == 0
    end
    
    it "should have origin airport in airports" do
      # FIXME TODO
    end
    
    it "should have destination airport in airports" do
      # FIXME TODO
    end
    
    it "should have origin country iso code in countries" do
      # FIXME TODO
    end
    
    it "should have destination country iso code in countries" do
      # FIXME TODO
    end
    
    it "should have airline name" do
      FlightSegment.where(:airline_name => nil).count.should == 0
    end
    
    it "should have aircraft description" do
      FlightSegment.where(:aircraft_description => nil).count.should == 0
    end
  end
end
