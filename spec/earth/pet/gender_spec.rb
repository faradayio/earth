require 'spec_helper'
require 'earth/pet/gender'

describe Gender do
  describe 'Sanity check', :sanity => true do
    it { Gender.count.should == 2 }
  end
end
