require 'spec_helper'
require 'earth/industry'
require 'earth/industry/mecs_energy'
require 'earth/industry/mecs_energy/data_miner'

describe MecsEnergy do
  before(:all) do
    MecsEnergy.auto_upgrade!
    MecsEnergy.run_data_miner!
  end

  describe 'data mining' do
    it 'retrieves Total US statistics' do
      apparel = MecsEnergy.find_by_naics_code '315'
      apparel.census_region.should be_nil
      # apparel.energy.should == 14_770_800_000
      # apparel.energy_units.should == 'megajoules'
      # apparel.electricity.should == 7_385_390_000
      # apparel.electricity_units.should == 'megajoules'
      # apparel.residual_fuel_oil.should be_nil
      # apparel.distillate_fuel_oil.should == 0
      # apparel.energy_units.should == 'megajoules'
      # apparel.natural_gas.should == 7
      # apparel.energy_units.should == 'megajoules'
      # apparel.lpg_and_ngl.should == 0
      # apparel.energy_units.should == 'megajoules'
      # apparel.coal.should == 0
      # apparel.energy_units.should == 'megajoules'
      # apparel.coke_and_breeze.should == 0
      # apparel.energy_units.should == 'megajoules'
      # apparel.other.should == 0
      # apparel.energy_units.should == 'megajoules'
    end
  end

  describe '.find_by_naics_code_and_census_region' do
    it 'finds an exact match' do
      MecsEnergy.find_by_naics_code_and_census_region('3122', '2').
        name.should == '3122-2'
    end
    it 'finds a parent category by prefix' do
      MecsEnergy.find_by_naics_code_and_census_region('312199', '2').
        name.should == '3121-2'
    end
    it 'returns nil if no match found' do
      MecsEnergy.find_by_naics_code_and_census_region('543211', '2').
        should be_nil
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
