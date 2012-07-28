require 'spec_helper'
require 'earth/air/flight_seat_class'

describe FlightSeatClass do
  describe "Sanity check", :sanity => true do
    let(:total) { FlightSeatClass.count }
    
    it "should have all the data" do
      total.should == 4
    end
  end
end
