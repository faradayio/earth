require 'spec_helper'
require 'earth/rail/rail_class'

describe RailClass do
  describe 'Sanity check', :sanity => true do
    it { RailClass.count.should == 6 }
  end
end
