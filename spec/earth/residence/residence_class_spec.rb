require 'spec_helper'
require 'earth/residence/residence_class'

describe ResidenceClass do
  describe '#classifications' do
    it "should return the residence class' classification" do
      ResidenceClass.find_or_create_by_name('Single-family house').classification.should == 'house'
      ResidenceClass.find_or_create_by_name('Condo').classification.should be_nil
    end
  end
  
  describe "Sanity check", :sanity => true do
    it { ResidenceClass.count.should == 5 }
  end
end
