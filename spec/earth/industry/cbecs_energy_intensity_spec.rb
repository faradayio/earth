require 'spec_helper'
require 'earth/industry/cbecs_energy_intensity'
require 'earth/industry/cbecs_energy_intensity/data_miner'

describe CbecsEnergyIntensity do
  before :all do
    CbecsEnergyIntensity.auto_upgrade!
  end
  before :each do
    CbecsEnergyIntensity.delete_all
  end
  
  describe '.find_by_naics_code_and_census_division_number' do
    before do
      CbecsEnergyIntensity.create! :naics_code => '44', :census_division_number => 1
      CbecsEnergyIntensity.create! :naics_code => '445', :census_division_number => 1
      CbecsEnergyIntensity.create! :naics_code => '621', :census_division_number => 1
      CbecsEnergyIntensity.create! :naics_code => '44', :census_division_number => 2
      CbecsEnergyIntensity.create! :naics_code => '445', :census_division_number => 2
      CbecsEnergyIntensity.create! :naics_code => '621', :census_division_number => 2
    end
    it 'finds an exact match' do
      record = CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('445', 2)
      record.naics_code.should == '445'
      record.census_division_number.should == 2
    end
    it 'finds a parent category when exact code is not present' do
      record = CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('4451', 2)
      record.naics_code.should == '445'
      record.census_division_number.should == 2
    end
    it 'does not find a sibling category' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('622', 2).
        should be_nil
    end
    it 'returns nil if no match found' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('8131', 1).
        should be_nil
    end
  end

  describe 'import', :slow => true do
    it 'fetches electric, natural gas, fuel oil, and distric heat data' do
      DataMiner.logger = Logger.new(STDOUT)
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      CbecsEnergyIntensity.run_data_miner!
      CbecsEnergyIntensity.all.count.should == 163  # 18 building uses * 9 census regions + 1 national avg

      CbecsEnergyIntensity.find_by_name ''
    end
  end
end
