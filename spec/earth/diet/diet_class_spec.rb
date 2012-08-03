require 'spec_helper'
require 'earth/diet/diet_class'

describe DietClass do
  describe 'Sanity check', :sanity => true do
    it { DietClass.count.should == 3 }
    
    describe 'fallback' do
      it { DietClass.fallback.name.should == 'standard' }
    end
    
    # FIXME TODO more sanity checks
  end
end
