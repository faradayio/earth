require 'spec_helper'
require 'earth/locality/census_region'

describe CensusRegion do
  describe 'Sanity check', :sanity => true do
    it { CensusRegion.count.should == 4 }
  end
end
