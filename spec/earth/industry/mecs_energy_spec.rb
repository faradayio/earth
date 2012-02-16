require 'spec_helper'
require 'earth/industry'
require 'earth/industry/mecs_energy/data_miner'

describe MecsEnergy do
  describe 'import', :slow => true do
    before do
      MecsEnergy.auto_upgrade!
      MecsEnergy.delete_all
    end
    it 'retrieves Total US statistics' do
      MecsEnergy.run_data_miner!
      MecsEnergy.count.should == 395
    end
  end
  
  describe 'verify imported data', :sanity => true do
    it 'spot checks the data' do
      apparel = MecsEnergy.find_by_naics_code '315'
      apparel.census_region_number.should be_nil
      apparel.energy.should be_within(10_000).of(14.trillion_btus.to(:megajoules))
      apparel.energy_units.should == 'megajoules'
      apparel.electricity.should == be_within(1_000).of(7.trillion_btus.to(:megajoules))
      apparel.electricity_units.should == 'megajoules'
      apparel.residual_fuel_oil.should == 0
      apparel.residual_fuel_oil_units.should == 'megajoules'
      apparel.distillate_fuel_oil.should == 0
      apparel.distillate_fuel_oil_units.should == 'megajoules'
      apparel.natural_gas.should == be_within(1_000).of(7.trillion_btus.to(:megajoules))
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
  
  describe '.find_by_naics_code_and_census_region_number' do
    it 'finds an exact match' do
      MecsEnergy.find_by_naics_code_and_census_region_number('311221', 2).
        name.should == '311221-2'
    end
    it 'finds a parent category when exact code is not present' do
      MecsEnergy.find_by_naics_code_and_census_region_number('3117', 2).
        name.should == '311-2'
    end
    it 'finds a parent category rather than a sibling category' do
      MecsEnergy.find_by_naics_code_and_census_region_number('311225', 2).
        name.should == '3112-2'
    end
    it 'returns nil if no match found' do
      MecsEnergy.find_by_naics_code_and_census_region_number('543211', 2).
        should be_nil
    end
  end
  
  describe '.find_by_naics_code' do
    it 'finds an exact match' do
      MecsEnergy.find_by_naics_code('311221').name.should == '311221-'
    end
    it 'finds a parent category when exact code is not present' do
      MecsEnergy.find_by_naics_code('3117').name.should == '311-'
    end
    it 'finds a parent category rather than a sibling category' do
      MecsEnergy.find_by_naics_code('311225').name.should == '3112-'
    end
    it 'returns nil if no match found' do
      MecsEnergy.find_by_naics_code('543211').should be_nil
    end
  end
  
  describe '#fuel_ratios' do
    it 'returns a list of fuel ratios for a given NAICS' do
      energy = MecsEnergy.new :energy => 100, :electricity => 20,
        :residual_fuel_oil => 1, :distillate_fuel_oil => 2,
        :natural_gas => 30, :lpg_and_ngl => 22, :coal => 22,
        :coke_and_breeze => 1, :other_fuel => 1
      energy.fuel_ratios.should == {
        :electricity => 0.20,
        :residual_fuel_oil => 0.01, :distillate_fuel_oil => 0.02,
        :natural_gas => 0.3, :lpg_and_ngl => 0.22, :coal => 0.22,
        :coke_and_breeze => 0.01, :other_fuel => 0.01
      }
    end
  end
end
