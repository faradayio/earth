require 'spec_helper'
require 'earth/air/bts_aircraft'

describe BtsAircraft do
  describe 'verify imported data', :sanity => true do
    it 'should have all the data' do
      BtsAircraft.count.should == 379
    end
  end
end
