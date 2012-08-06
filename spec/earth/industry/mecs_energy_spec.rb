require 'spec_helper'
require "#{Earth::FACTORY_DIR}/mecs_energy"

describe MecsEnergy do
  describe '#fuel_ratios' do
    it 'calculates based on sum of all fuels when no fuels are missing' do
      # Energy < sum all fuels
      energy = MecsEnergy.new(
        :energy => 50,
        :electricity => 25,
        :residual_fuel_oil => 10,
        :distillate_fuel_oil => 10,
        :natural_gas => 25,
        :lpg_and_ngl => 5,
        :coal => 5,
        :coke_and_breeze => 15,
        :other_fuel => 5
      )
      energy.fuel_ratios.should == {
        :electricity => 0.25,
        :residual_fuel_oil => 0.1,
        :distillate_fuel_oil => 0.1,
        :natural_gas => 0.25,
        :lpg_and_ngl => 0.05,
        :coal => 0.05,
        :coke_and_breeze => 0.15,
        :other_fuel => 0.05
      }
      
      # Energy = sum all fuels
      energy = MecsEnergy.new(
        :energy => 100,
        :electricity => 25,
        :residual_fuel_oil => 10,
        :distillate_fuel_oil => 10,
        :natural_gas => 25,
        :lpg_and_ngl => 5,
        :coal => 5,
        :coke_and_breeze => 15,
        :other_fuel => 5
      )
      energy.fuel_ratios.should == {
        :electricity => 0.25,
        :residual_fuel_oil => 0.1,
        :distillate_fuel_oil => 0.1,
        :natural_gas => 0.25,
        :lpg_and_ngl => 0.05,
        :coal => 0.05,
        :coke_and_breeze => 0.15,
        :other_fuel => 0.05
      }
      
      # Energy > sum of all fuels
      energy = MecsEnergy.new(
        :energy => 200,
        :electricity => 25,
        :residual_fuel_oil => 75,
        :distillate_fuel_oil => 0,
        :natural_gas => 0,
        :lpg_and_ngl => 0,
        :coal => 0,
        :coke_and_breeze => 0,
        :other_fuel => 0
      )
      energy.fuel_ratios.should == {
        :electricity => 0.25,
        :residual_fuel_oil => 0.75
      }
    end
    
    it 'ignores missing fuels when energy <= sum of all fuels' do
      # Energy < sum of all fuels
      energy = MecsEnergy.new(
        :energy => 50,
        :electricity => 25,
        :residual_fuel_oil => 75
      )
      energy.fuel_ratios.should == {
        :electricity => 0.25,
        :residual_fuel_oil => 0.75
      }
      
      # Energy = sum of all fuels
      energy = MecsEnergy.new(
        :energy => 100,
        :electricity => 25,
        :residual_fuel_oil => 75
      )
      energy.fuel_ratios.should == {
        :electricity => 0.25,
        :residual_fuel_oil => 0.75
      }
    end
    
    it 'adjusts for missing fuels when energy > sum of all fuels' do
      energy = MecsEnergy.new(
        :energy => 200,
        :electricity => 25,
        :residual_fuel_oil => 75
      )
      energy.fuel_ratios.should == {
        :electricity => 0.125,
        :residual_fuel_oil => 0.375,
        :coal => 0.5
      }
    end
    
    it 'returns nil if energy is missing or zero' do
      energy = MecsEnergy.new(
        :energy => nil,
        :electricity => 25,
        :residual_fuel_oil => 75
      )
      energy.fuel_ratios.should be_nil
      
      energy = MecsEnergy.new(
        :energy => 0,
        :electricity => 25,
        :residual_fuel_oil => 75
      )
      energy.fuel_ratios.should be_nil
    end
    
    it 'returns nil if all fuels are zero' do
      energy = MecsEnergy.new(
        :energy => 1,
        :electricity => 0,
        :residual_fuel_oil => 0,
        :distillate_fuel_oil => 0,
        :natural_gas => 0,
        :lpg_and_ngl => 0,
        :coal => 0,
        :coke_and_breeze => 0,
        :other_fuel => 0
      )
      energy.fuel_ratios.should be_nil
    end
  end
  
  describe '.find_by_naics_code_and_census_region_number' do
    it 'finds an exact match' do
      energy = FactoryGirl.create :mecs_energy, :r1111c1
      MecsEnergy.find_by_naics_code_and_census_region_number('1111', 1).should == energy
    end
    it 'finds a parent category when exact code is not present' do
      energy = FactoryGirl.create :mecs_energy, :r111c1
      MecsEnergy.find_by_naics_code_and_census_region_number('111', 1).should == energy
    end
    it 'finds same category nationwide when census region is not present' do
      energy = FactoryGirl.create :mecs_energy, :r1111
      MecsEnergy.find_by_naics_code_and_census_region_number('1111', 1).should == energy
    end
    it 'keeps looking if fuel ratios is invalid' do
      FactoryGirl.create :mecs_energy, :r1111c2
      energy = FactoryGirl.create :mecs_energy, :r1111
      MecsEnergy.find_by_naics_code_and_census_region_number('1111', 2).should == energy
    end
    it 'finds a parent category rather than a sibling category' do
      FactoryGirl.create :mecs_energy, :r1112c1
      energy = FactoryGirl.create :mecs_energy, :r11c1
      MecsEnergy.find_by_naics_code_and_census_region_number('1111', 1).should == energy
    end
    it 'returns nil if no match found' do
      MecsEnergy.find_by_naics_code_and_census_region_number('1111', 1).should be_nil
    end
  end
  
  describe '.find_by_naics_code' do
    it 'finds an exact match' do
      energy = FactoryGirl.create :mecs_energy, :r1111
      MecsEnergy.find_by_naics_code('1111').should == energy
    end
    it 'finds a parent category when exact code is not present' do
      energy = FactoryGirl.create :mecs_energy, :r111
      MecsEnergy.find_by_naics_code('1111').should == energy
    end
    it 'finds a parent category rather than a sibling category' do
      FactoryGirl.create :mecs_energy, :r1112
      energy = FactoryGirl.create :mecs_energy, :r11
      MecsEnergy.find_by_naics_code('1111').should == energy
    end
    it 'returns nil if no match found' do
      MecsEnergy.find_by_naics_code('1111').should be_nil
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it 'should have all the data' do
      MecsEnergy.count.should == 395
    end
    it 'spot checks the data' do
      apparel = MecsEnergy.find_by_naics_code '315'
      apparel.census_region_number.should be_nil
      apparel.energy.should be_within(20_000).of(14770781900)
      apparel.energy_units.should == 'megajoules'
      apparel.electricity.should be_within(1_000).of(7.trillion_btus.to(:megajoules))
      apparel.electricity_units.should == 'megajoules'
      apparel.residual_fuel_oil.should == 0
      apparel.residual_fuel_oil_units.should == 'megajoules'
      apparel.distillate_fuel_oil.should == 0
      apparel.distillate_fuel_oil_units.should == 'megajoules'
      apparel.natural_gas.should be_within(1_000).of(7.trillion_btus.to(:megajoules))
      apparel.natural_gas_units.should == 'megajoules'
      apparel.lpg_and_ngl.should == 0
      apparel.lpg_and_ngl_units.should == 'megajoules'
      apparel.coal.should == 0
      apparel.coal_units.should == 'megajoules'
      apparel.coke_and_breeze.should == 0
      apparel.coke_and_breeze_units.should == 'megajoules'
      apparel.other_fuel.should == 0
      apparel.other_fuel_units.should == 'megajoules'
    end
  end
end
