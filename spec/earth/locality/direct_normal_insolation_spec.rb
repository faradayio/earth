require 'spec_helper'
require 'earth/locality/direct_normal_insolation'

describe DirectNormalInsolation do
  describe 'Sanity check', :sanity => true do
    it { DirectNormalInsolation.count.should == 90508 }
  end
end
