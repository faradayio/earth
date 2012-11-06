require 'spec_helper'
require 'earth/locality/global_horizontal_insolation'

describe GlobalHorizontalInsolation do
  describe 'Sanity check', :sanity => true do
    it { GlobalHorizontalInsolation.count.should == 138970 }
  end
end
