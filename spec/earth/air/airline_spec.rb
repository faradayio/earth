require 'spec_helper'
require 'earth/air/airline'

describe Airline do
  describe "verify imported data", :sanity => true do
    it "should have all the data" do
      Airline.count.should be_within(10).of(1523)
    end
  end
end
