require 'spec_helper'
require 'earth/pet/breed_gender'

describe BreedGender do
  describe 'Sanity check', :sanity => true do
    it { BreedGender.count.should == 586 }
  end
end
