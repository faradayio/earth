require 'spec_helper'
require 'earth/industry/mecs_energy'
require 'earth/industry/mecs_energy/data_miner'

describe MecsEnergy do
  before(:all) do
    MecsEnergy.auto_upgrade!
    MecsEnergy.run_data_miner!
  end

  describe 'data mining' do
    it 'retrieves Total US statistics' do
      puts MecsEnergy.all.inspect
      apparel = MecsEnergy.find_by_naics_code '315'
      apparel.census_region.should be_nil
      apparal.total.should == 14
      apparal.net_electricity.should == 7
      apparal.residual_fuel_oil.should be_nil
      apparal.distillate_fuel_oil.should be_nil
      apparal.natural_gas.should == 7
      apparal.lpg_and_ngl.should be_nil
      apparal.coal.should == 0
      apparal.coke_and_breeze.should == 0
      apparal.other.should be_nil
    end
  end

  describe '.find_by_naics_code_and_census_region' do
    before do
      MecsEnergy.create! :naics_code => '312', :census_region => '1'
      MecsEnergy.create! :naics_code => '3121', :census_region => '1'
      MecsEnergy.create! :naics_code => '3122', :census_region => '1'
      MecsEnergy.create! :naics_code => '312', :census_region => '2'
      MecsEnergy.create! :naics_code => '3121', :census_region => '2'
      MecsEnergy.create! :naics_code => '3122', :census_region => '2'
      MecsEnergy.create! :naics_code => '312211', :census_region => '2'
    end
    it 'finds an exact match' do
      MecsEnergy.find_by_naics_code_and_census_region('312211', '2').
        naics_code.should == '312211'
    end
    it 'finds a parent category by prefix' do
      MecsEnergy.find_by_naics_code_and_census_region('312199', '2').
        naics_code.should == '3121'
    end
    it 'returns nil if no match found' do
      MecsEnergy.find_by_naics_code_and_census_region('543211', '2').
        should be_nil
    end
  end

  describe '#fuel_ratios' do
    it 'returns a list of fuel ratios for a given NAICS' do
      energy = MecsEnergy.new :total => 100, :net_electricity => 20,
        :residual_fuel_oil => 1, :distillate_fuel_oil => 2,
        :natural_gas => 30, :lpg_and_ngl => 22, :coal => 22,
        :coke_and_breeze => 1, :other => 1
      energy.fuel_ratios.should == {
        :net_electricity => 0.20,
        :residual_fuel_oil => 0.01, :distillate_fuel_oil => 0.02,
        :natural_gas => 0.3, :lpg_and_ngl => 0.22, :coal => 0.22,
        :coke_and_breeze => 0.01, :other => 0.01
      }
    end
  end

  describe '.normalize_fuels' do
    it 'transforms Q (witheld due to stddev error) into 0' do
      MecsEnergy.all.each do |energy|
        MecsEnergy::FUELS.each do |fuel|
          %w{W Q *}.should_not include(energy.send(fuel))
        end
      end
    end
  end
end

