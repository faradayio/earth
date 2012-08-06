require 'spec_helper'
require 'earth/residence/urbanity'

describe Urbanity do
  describe "Sanity check", :sanity => true do
    it { Urbanity.count.should == 4 }
  end
end
