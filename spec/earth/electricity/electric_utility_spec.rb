require 'spec_helper'
require 'earth/electricity/electric_utility'

describe ElectricUtility do
  before :all do
    Earth.init :electricity, :load_data_miner => true, :skip_parent_associations => :true
  end
  
  describe 'import electric utility data', :data_miner => true do
    it 'imports data' do
      ElectricUtility.run_data_miner!
    end
  end
  
  describe 'verify electric utility data', :sanity => true do
    it 'should include all U.S. utilities' do
      ElectricUtility.count.should == 3265
    end

    it 'should have valid state postal abbreviations' do
      ElectricUtility.where("state_postal_abbreviation IS NOT NULL").select("DISTINCT state_postal_abbreviation").each do |utility|
        utility.state.should be_kind_of(State)
      end
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

    it 'should reveal which utilities have implemented the Green Button program' do
      ElectricUtility.find(14328).green_button_implementer?.should == true
    end

    it 'should reveal which utilities have committed to the Green Button program' do
      ElectricUtility.find(14940).green_button_committer?.should == true
    end
  end
end
