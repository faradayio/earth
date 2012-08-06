require 'spec_helper'
require "#{Earth::FACTORY_DIR}/green_button_adoption"

describe GreenButtonAdoption do
  describe '.committed?(*names)' do
    it "should return true for a utility that has committed to the green button" do
      FactoryGirl.create :green_button_adoption, :committed_utility
      FactoryGirl.create :green_button_adoption, :implemented_utility
      
      GreenButtonAdoption.committed?('ACU').should == false
      GreenButtonAdoption.committed?('ACU', 'A committed utility').should == true
      GreenButtonAdoption.committed?('An implemented utility').should == false
    end
  end
  
  describe '.implemented?(*names)' do
    it "should return true for a utility that has implemented the green button" do
      FactoryGirl.create :green_button_adoption, :committed_utility
      FactoryGirl.create :green_button_adoption, :implemented_utility
      
      GreenButtonAdoption.implemented?('AIU').should == false
      GreenButtonAdoption.implemented?('AIU', 'An implemented utility').should == true
      GreenButtonAdoption.implemented?('A committed utility').should == false
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { GreenButtonAdoption.count.should == 23 }
    
    it 'should recognize that PG&E has implemented' do
      GreenButtonAdoption.find('PG&E').implemented?.should == true
    end
    
    it 'should recognize that PPL has committed' do
      GreenButtonAdoption.find('PPL').committed?.should == true
    end
  end
end
