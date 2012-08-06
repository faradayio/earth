require 'spec_helper'
require 'earth/air/flight_distance_class_seat_class'

describe FlightDistanceClassSeatClass do
  describe "Sanity check", :sanity => true do
    let(:total) { FlightDistanceClassSeatClass.count }
    let(:short_econ) { FlightDistanceClassSeatClass.find('short haul economy') }
    
    it "should have all the data" do
      total.should == 7
    end
    
    # spot check
    it { short_econ.multiplier.should be_within(5e-5).of(0.9532) }
    
    describe '.fallback' do
      let(:fallback) { FlightDistanceClassSeatClass.fallback }
      it { fallback.name.should == 'fallback' }
      it { fallback.multiplier.should be_within(5e-5).of(1.0) }
    end
  end
end
