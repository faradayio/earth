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
      CbecsEnergyIntensity.all.count.should == 140  # 14 building uses * 9 census regions + 14 national avg

      # check census regions
      regionals = CbecsEnergyIntensity.regional
      nationals.count.should == 14
      nationals.each do |national|
        national.elecricity.should > 1
        national.electricity_intensity.should > 1
        national.natural_gas.should > 1
        national.natural_gas_intensity.should > 1
        national.fuel_oil.should > 1
        national.fuel_oil_intensity.should > 1
        # There is no regional district heat data
        national.district_heat.should be_nil
        national.district_heat_intensity.should be_nil
      end

      # check total us averages
      nationals = CbecsEnergyIntensity.national
      nationals.count.should == 14
      nationals.each do |national|
        national.elecricity.should > 1
        national.electricity_intensity.should > 1
        national.natural_gas.should > 1
        national.natural_gas_intensity.should > 1
        national.fuel_oil.should > 1
        national.fuel_oil_intensity.should > 1
        national.district_heat.should > 1
        national.district_heat_intensity.should > 1
      end
    end 
  end
end
