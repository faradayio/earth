require 'spec_helper'
require 'earth/air/airline'

describe Airline do
  describe "Sanity check", :sanity => true do
    it "should have all the data" do
      Airline.count.should == 1519
    end
  end
end
