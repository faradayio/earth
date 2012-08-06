require 'spec_helper'
require 'earth/air/bts_aircraft'

describe BtsAircraft do
  describe 'Sanity check', :sanity => true do
    it 'should have all the data' do
      BtsAircraft.count.should == 378
    end
  end
end
