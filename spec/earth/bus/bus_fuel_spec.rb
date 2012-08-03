require 'spec_helper'
require 'earth/bus/bus_fuel'

describe 'BusFuel' do
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      BusFuel.count.should == 7
    end
    it 'is related to fuels' do
      BusFuel.last.fuel.should_not be_nil
    end
  end
end
