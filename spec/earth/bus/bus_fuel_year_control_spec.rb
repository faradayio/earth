require 'spec_helper'
require 'earth/bus/bus_fuel_year_control'

describe 'BusFuelYearControl' do
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      BusFuelYearControl.count.should == 67
    end
    it 'is related to BusFuelControl' do
      BusFuelYearControl.first.control.should_not be_nil
    end
  end
end
