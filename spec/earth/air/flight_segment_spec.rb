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
      FlightSegment.where(:year => 2011).count.should > 357_687
    end
    
    it "should have year from 2009 to present" do
      FlightSegment.where("year IS NULL OR year < 2009 OR year > #{::Time.now.year}").count.should == 0
    end
    
    it "should have data through 7 months ago" do
      latest = Date.today << 7
      FlightSegment.maximum(:year).should == latest.year
      FlightSegment.where(:year => latest.year).maximum(:month).should == latest.month
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
