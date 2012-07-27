require 'spec_helper'
require "#{Earth::FACTORY_DIR}/flight_distance_class"

describe FlightDistanceClass do
  describe ".find_by_distance" do
    it "returns a distance class where min distance > distance and max distance <= distance" do
      FactoryGirl.create :flight_distance_class, :short
      FactoryGirl.create :flight_distance_class, :long
      
      fdc = FlightDistanceClass.find_by_distance 3500
      fdc.min_distance.should < 3500
      fdc.max_distance.should >= 3500
    end
    
    it "returns nil unless distance between 0 and half the earth's circumference" do
      FactoryGirl.create :flight_distance_class, :short
      FactoryGirl.create :flight_distance_class, :long
      
      FlightDistanceClass.find_by_distance(-1000).should be_nil
      FlightDistanceClass.find_by_distance(0).should be_nil
      FlightDistanceClass.find_by_distance(20037.61).should be_nil
    end
  end
  
  describe "Sanity check", :sanity => true do
    let(:total) { FlightDistanceClass.count }
    
    it "should have all the data" do
      total.should == 2
    end
    
    it "should have distances > 0" do
      FlightDistanceClass.where('distance > 0').count.should == total
    end
    
    it "the smallest min distance should be 0" do
      FlightDistanceClass.all.map(&:min_distance).min.should == 0
    end
    
    it "the largest max distance should be half the earth's circumference" do
      FlightDistanceClass.all.map(&:max_distance).max.should == 20037.6
    end
  end
end
