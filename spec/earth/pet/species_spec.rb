require 'spec_helper'
require 'earth/pet/species'

describe Species do
  # FIXME TODO method tests
  
  describe 'Sanity check', :sanity => true do
    it { Species.count.should == 18 }
    
    describe 'fallback' do
      it 'should have marginal dietary requirement of 0 when there is no data' do
        Species.delete_all
        Species.fallback.marginal_dietary_requirement.should == 0
      end
    end
  
  # FIXME TODO more sanity checks
  end
end
