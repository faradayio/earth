require 'spec_helper'
require 'earth/air/flight_distance_class'

describe FlightDistanceClass do
  describe "when importing data", :data_miner => true do
    before do
      Earth.init :air, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it "imports all naics codes" do
      FlightDistanceClass.run_data_miner!
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "should have all the data" do
      FlightDistanceClass.count.should == 2
    end
    
    it "should have distances > 0" do
      FlightDistanceClass.where('distance <= 0 OR distance IS NULL').count.should == 0
    end
    
    it "the smallest min distance should be 0" do
      FlightDistanceClass.all.map(&:min_distance).min.should == 0
    end
    
    it "the largest max distance should be half the earth's circumference" do
      FlightDistanceClass.all.map(&:max_distance).max.should == 20037.6
    end
  end
  
  describe ".find_by_distance" do
    it "should return a distance class where min distance > distance and max distance <= distance" do
      distance_class = FlightDistanceClass.find_by_distance(3700)
      distance_class.min_distance.should < 3700
      distance_class.max_distance.should >= 3700
    end
    
    it "should return nil unless distance between 0 and half the earth's circumference" do
      FlightDistanceClass.find_by_distance(-1000).should be_nil
      FlightDistanceClass.find_by_distance(0).should be_nil
      FlightDistanceClass.find_by_distance(20037.61).should be_nil
    end
  end
end
