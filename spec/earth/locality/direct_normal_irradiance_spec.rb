require 'spec_helper'
require 'earth/locality/direct_normal_irradiance'

describe DirectNormalIrradiance do
  describe 'Sanity check', :sanity => true do
    it { DirectNormalIrradiance.count.should == 90508 }
  end
end
