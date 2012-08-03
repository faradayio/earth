require 'spec_helper'
require 'earth/hospitality/lodging_class'

describe LodgingClass do
  describe 'verify imported data', :sanity => true do
    it { LodgingClass.count.should == 3 }
  end
end
