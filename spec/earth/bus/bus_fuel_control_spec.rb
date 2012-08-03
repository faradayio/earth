require 'spec_helper'
require 'earth/bus/bus_fuel_control'

describe BusFuelControl do
  describe 'Sanity check', :sanity => true do
    it { BusFuelControl.count.should == 9 }
  end
end
