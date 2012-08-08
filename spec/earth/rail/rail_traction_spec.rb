require 'spec_helper'
require 'earth/rail/rail_traction'

describe RailTraction do
  describe 'Sanity check', :sanity => true do
    it { RailTraction.count.should == 2 }
  end
end
