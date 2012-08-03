require 'spec_helper'
require "#{Earth::FACTORY_DIR}/electric_utility"
require "#{Earth::FACTORY_DIR}/green_button_adoption"

describe ElectricUtility do
  describe '#green_button_committer?' do
    it 'should reveal which utilities have committed to the Green Button program' do
      FactoryGirl.create :green_button_adoption, :committed_utility
      FactoryGirl.create :green_button_adoption, :implemented_utility
      
      FactoryGirl.create(:electric_utility, :committed_utility).green_button_committer?.should == true
      FactoryGirl.create(:electric_utility, :implemented_utility).green_button_committer?.should == false
    end
  end
  
  describe '#green_button_implementer?' do
    it 'should reveal which utilities have implemented the Green Button program' do
      FactoryGirl.create :green_button_adoption, :committed_utility
      FactoryGirl.create :green_button_adoption, :implemented_utility
      
      FactoryGirl.create(:electric_utility, :committed_utility).green_button_implementer?.should == false
      FactoryGirl.create(:electric_utility, :implemented_utility).green_button_implementer?.should == true
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it 'should include all U.S. utilities' do
      ElectricUtility.count.should == 3265
    end
    
    it 'should have valid NERC region abbreviations' do
      ElectricUtility.where("nerc_region_abbreviation IS NOT NULL").select("DISTINCT nerc_region_abbreviation").each do |utility|
        %w{ NPCC RFC SERC FRCC MRO SPP TRE WECC ASCC HICC}.include?(utility.nerc_region_abbreviation).should be_true
      end
    end
    
    it 'should have valid second NERC region abbreviations' do
      ElectricUtility.where("second_nerc_region_abbreviation IS NOT NULL").select("DISTINCT second_nerc_region_abbreviation").each do |utility|
        %w{ NPCC RFC SERC FRCC MRO SPP TRE WECC ASCC HICC}.include?(utility.second_nerc_region_abbreviation).should be_true
      end
    end
    
    it 'should include, specifically, MG&E' do
      ElectricUtility.find(11479).name.should == 'Madison Gas & Electric Co'
    end
    
    it 'should include aliases' do
      ElectricUtility.find(14328).nickname.should == 'PG&E'
    end
    
    # spot checks
    it { ElectricUtility.find(14328).green_button_implementer?.should == true }
    it { ElectricUtility.find(14940).green_button_committer?.should == true }
  end
end
