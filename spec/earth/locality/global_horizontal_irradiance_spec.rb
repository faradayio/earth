require 'spec_helper'
require 'earth/locality/global_horizontal_irradiance'

describe GlobalHorizontalIrradiance do
  describe 'Sanity check', :sanity => true do
    it { GlobalHorizontalIrradiance.count.should == 138970 }
  end
end
