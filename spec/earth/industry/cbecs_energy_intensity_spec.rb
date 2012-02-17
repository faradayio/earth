require 'spec_helper'
require 'earth/industry/cbecs_energy_intensity'

def create_cbecs(name, args)
  c = CbecsEnergyIntensity.new args
  c.name = name
  c.save!
end

describe CbecsEnergyIntensity do
  describe 'import', :slow => true do
    before do
      require 'earth/industry/cbecs_energy_intensity/data_miner'
      CbecsEnergyIntensity.auto_upgrade!
      CbecsEnergyIntensity.delete_all
    end
    it 'fetches electric, natural gas, fuel oil, and distric heat data' do
      CbecsEnergyIntensity.run_data_miner!
      CbecsEnergyIntensity.count.should == 182
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'checks census divisions' do
      divisionals = CbecsEnergyIntensity.divisional
      divisionals.count.should == 117
      spot_check(divisionals, [
        [[:principal_building_activity, :census_region_number, :census_division_number], [:electricity, :natural_gas]],
        
        [['Education', 1, 1], [:nil, :nil]],
        [['Education', 1, 2], [:present, :present]],
      ])
    end
    
    it 'checks cenusus regions' do
      regionals = CbecsEnergyIntensity.regional
      regionals.count.should == 52
      spot_check(regionals, [
        [[:principal_building_activity, :census_region_number], [:electricity, :fuel_oil]],
        [['Education', 1], [:present, :present]],
        [['Education', 2], [:present, :nil]],
        [['Education', 3], [:present, :nil]],
        [['Education', 4], [:present, :nil]],
        [['Health Care', 1], [:present, :nil]],
        [['Health Care', 2], [:present, :nil]],
        [['Health Care', 3], [:present, :present]],
        [['Health Care', 4], [:present, :present]],
        
      ])
    end
    
    it 'checks US averages' do
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
  
  describe '.find_by_naics_code_and_census_division_number' do
    it 'finds an exact match' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('445', 2).name.should == '445-1-2'
    end
    it 'finds a parent category when exact code is not present' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('4451', 2).name.should == '445-1-2'
    end
    it 'does not find a sibling category' do
      create_cbecs '72221-1-2', :naics_code => '72221', :census_division_number => 2, :census_region_number => 1
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('72229', 2).name.should == '722-1-2'
      CbecsEnergyIntensity.delete '72221-1-2'
    end
    it 'returns nil if no match found' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('48', 2).should be_nil
    end
  end
  
  describe '.find_by_naics_code_and_census_region_number' do
    it 'finds an exact match' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_region_number('445', 2).name.should == '445-2'
    end
    it 'finds a parent category when exact code is not present' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_region_number('4451', 2).name.should == '445-2'
    end
    it 'does not find a sibling category' do
      create_cbecs '72221-2', :naics_code => '72221', :census_region_number => 2
      CbecsEnergyIntensity.find_by_naics_code_and_census_region_number('72229', 2).name.should == '722-2'
      CbecsEnergyIntensity.delete '72221-2'
    end
    it 'returns nil if no match found' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_region_number('48', 2).should be_nil
    end
  end
  
  describe '.find_by_naics_code' do
    it 'finds an exact match' do
      CbecsEnergyIntensity.find_by_naics_code('445').name.should == '445'
    end
    it 'finds a parent category when exact code is not present' do
      CbecsEnergyIntensity.find_by_naics_code('4451').name.should == '445'
    end
    it 'does not find a sibling category' do
      create_cbecs '72221', :naics_code => '72221'
      CbecsEnergyIntensity.find_by_naics_code('72229').name.should == '722'
      CbecsEnergyIntensity.delete '72221'
    end
    it 'returns nil if no match found' do
      CbecsEnergyIntensity.find_by_naics_code('48').should be_nil
    end
  end
  
  describe '#fuel_ratios' do
    it 'makes ratios from fuel energies' do
      cbecs = CbecsEnergyIntensity.new :name => '1', :electricity => 1000, :natural_gas => 2000, :fuel_oil => 500, :district_heat => 0
      cbecs.fuel_ratios.should == {
        :electricity => 0.2857142857142857,
        :natural_gas => 0.5714285714285714,
        :fuel_oil => 0.14285714285714285,
        :district_heat => 0.0
      }
    end
  end
end
