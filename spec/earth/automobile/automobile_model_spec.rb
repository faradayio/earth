require 'spec_helper'
require 'earth/automobile/automobile_model'

describe AutomobileModel do
  describe 'Sanity check', :sanity => true do
    it { AutomobileModel.count.should == 2299 }
  end
end
