require 'spec_helper'
require 'earth/locality/photovoltaic_irradiance'

describe PhotovoltaicIrradiance do
  describe 'Sanity check', :sanity => true do
    it { PhotovoltaicIrradiance.count.should == 90469 }
  end
end
