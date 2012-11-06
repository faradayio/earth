require 'spec_helper'
require 'earth/locality/photovoltaic_insolation'

describe PhotovoltaicInsolation do
  describe 'Sanity check', :sanity => true do
    it { PhotovoltaicInsolation.count.should == 90469 }
  end
end
