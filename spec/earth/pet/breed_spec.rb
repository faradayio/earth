require 'spec_helper'
require 'earth/pet/breed'

describe Breed do
  describe 'Sanity check', :sanity => true do
    it { Breed.count.should == 522 }
  end
end
