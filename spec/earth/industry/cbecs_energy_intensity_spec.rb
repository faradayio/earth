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
      CbecsEnergyIntensity.run_data_miner!

      # check census divisions
      divisionals = CbecsEnergyIntensity.divisional
      divisionals.count.should == 117
      spot_check(divisionals, [
        [[:principal_building_activity, :census_region_number, :census_division_number], [:electricity, :natural_gas]],

        [['Education', 1, 1], [:nil, :nil]],
        [['Education', 1, 2], [:present, :present]],
      ])

      # check census regions
      regionals = CbecsEnergyIntensity.regional
      regionals.count.should == 52
      spot_check(regionals, [
        [[:principal_building_activity, :census_region_number], [:electricity, :fuel_oil]],
        # Regional fuel oil
        [['Education', 1], [:present, :present]],
        [['Education', 2], [:present, :nil]],
        [['Education', 3], [:present, :nil]],
        [['Education', 4], [:present, :nil]],

        [['Health Care', 1], [:present, :nil]],
        [['Health Care', 2], [:present, :nil]],
        [['Health Care', 3], [:present, :present]],
        [['Health Care', 4], [:present, :present]],
      ])

      # check total us averages
      nationals = CbecsEnergyIntensity.national
      nationals.count.should == 13
      spot_check(nationals, [
        [[:principal_building_activity], [:electricity, :fuel_oil, :district_heat]],
        [['Education'],                  [:present,     :present,  :present]],
        [['Lodging'],                    [:present,     :present,  :nil]],
        [['Office'],                     [:present,     :present,  :present]],
      ])
    end 
  end
end
