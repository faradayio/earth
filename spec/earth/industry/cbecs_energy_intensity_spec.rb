require 'spec_helper'
require "#{Earth::FACTORY_DIR}/cbecs_energy_intensity"

describe CbecsEnergyIntensity do
  describe '.find_by_naics_code_and_census_division_number' do
    it 'finds an exact match' do
      intensity = FactoryGirl.create :cbecs_energy_intensity, :i1111d1
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('1111', 1).should == intensity
    end
    it 'finds a parent category when exact code is not present' do
      intensity = FactoryGirl.create :cbecs_energy_intensity, :i1111d1
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('11111', 1).should == intensity
    end
    it 'does not find a sibling category' do
      FactoryGirl.create :cbecs_energy_intensity, :i1112d1
      intensity = FactoryGirl.create :cbecs_energy_intensity, :i11d1
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('1111', 1).should == intensity
    end
    it 'returns nil if no match found' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_division_number('1111', 1).should be_nil
    end
  end
  
  describe '.find_by_naics_code_and_census_region_number' do
    it 'finds an exact match' do
      intensity = FactoryGirl.create :cbecs_energy_intensity, :i1111r1
      CbecsEnergyIntensity.find_by_naics_code_and_census_region_number('1111', 1).should == intensity
    end
    it 'finds a parent category when exact code is not present' do
      intensity = FactoryGirl.create :cbecs_energy_intensity, :i1111r1
      CbecsEnergyIntensity.find_by_naics_code_and_census_region_number('11111', 1).should == intensity
    end
    it 'does not find a sibling category' do
      FactoryGirl.create :cbecs_energy_intensity, :i1112r1
      intensity = FactoryGirl.create :cbecs_energy_intensity, :i11r1
      CbecsEnergyIntensity.find_by_naics_code_and_census_region_number('1111', 1).should == intensity
    end
    it 'returns nil if no match found' do
      CbecsEnergyIntensity.find_by_naics_code_and_census_region_number('1111', 1).should be_nil
    end
  end
  
  describe '.find_by_naics_code' do
    it 'finds an exact match' do
      intensity = FactoryGirl.create :cbecs_energy_intensity, :i1111
      CbecsEnergyIntensity.find_by_naics_code('1111').should == intensity
    end
    it 'finds a parent category when exact code is not present' do
      intensity = FactoryGirl.create :cbecs_energy_intensity, :i1111
      CbecsEnergyIntensity.find_by_naics_code('11111').should == intensity
    end
    it 'does not find a sibling category' do
      FactoryGirl.create :cbecs_energy_intensity, :i1112
      intensity = FactoryGirl.create :cbecs_energy_intensity, :i11
      CbecsEnergyIntensity.find_by_naics_code('1111').should == intensity
    end
    it 'returns nil if no match found' do
      CbecsEnergyIntensity.find_by_naics_code('1111').should be_nil
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
  
  describe 'Sanity check', :sanity => true do
    it 'imports the right number of records' do
      CbecsEnergyIntensity.count.should == 182
    end
    
    #TODO check values
    it 'checks census divisions' do
      divisionals = CbecsEnergyIntensity.divisional
      divisionals.count.should == 117
      spot_check(divisionals, [
        [[:principal_building_activity, :census_region_number, :census_division_number], [:electricity, :natural_gas]],
        [['Education', 1, 1], [:nil, :nil]],
        [['Education', 1, 2], [:present, :present]],
      ])
    end
    
    # TODO check values
    # [[:principal_building_activity, :census_region_number], [:electricity, :fuel_oil]],
    # [['Education', 1], [46_800_000_000, 44_749_338_478]],
    # [['Education', 2], [72_000_000_000, :nil]],
    # [['Education', 3], [208_800_000_000, :nil]],
    # [['Education', 4], [61_200_000_000, :nil]],
    # [['Health Care', 1], [36_000_000_000, :nil]],
    # [['Health Care', 2], [64_800_000_000, :nil]],
    # [['Health Care', 3], [111_600_000_000, 2_697_655_156]],
    # [['Health Care', 4], [43_200_000_000, 1_110_799_182]],
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
    
    #TODO check values
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
end
