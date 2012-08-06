require 'spec_helper'
require 'earth/hospitality/lodging_class'

describe LodgingClass do
  describe 'Sanity check', :sanity => true do
    it { LodgingClass.count.should == 3 }
  end
end
