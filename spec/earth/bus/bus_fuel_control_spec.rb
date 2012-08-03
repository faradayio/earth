require 'spec_helper'
require 'earth/bus/bus_fuel_control'

describe 'BusFuelControl' do
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      BusFuelControl.count.should == 9
    end
  end
end
