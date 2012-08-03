require 'spec_helper'
require 'earth/computation/computation_carrier_region'

describe ComputationCarrierRegion do
  describe 'Sanity check', :sanity => true do
    it { ComputationCarrierRegion.count.should == 4 }
    
    # FIXME TODO more sanity checks
  end
end
