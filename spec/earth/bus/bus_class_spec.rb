require 'spec_helper'
require 'earth/bus/bus_class'

describe BusClass do
  describe 'Sanity check', :sanity => true do
    it { BusClass.count.should == 2 }
    
    # FIXME TODO more sanity checks
  end
end
