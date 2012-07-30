require 'spec_helper'
require 'earth/fuel/fuel'
require 'earth/fuel/fuel/data_miner'
require 'earth/fuel/fuel_year' # methods are delegated to FuelYear if value in fuels is null

describe Fuel do
  describe 'after importing data', :sanity => true do
    it 'should have all the data' do
      Fuel.count.should == 23
    end
    
    it 'should have a record for district heat' do
      district_heat = Fuel.find 'District Heat'
      district_heat.co2_emission_factor.should be_within(5e-6).of(0.07598)
    end
    
    # TODO is there a way to check whether the value in the fuels table is NULL?
    it 'should check FuelYear for any missing values' do
      gasoline = Fuel.find('Motor Gasoline')
      gasoline_years = FuelYear.where(:fuel_name => 'Motor Gasoline')
      latest_gasoline_year = gasoline_years.find_by_year(gasoline_years.maximum(:year))
      gasoline.energy_content.should == latest_gasoline_year.energy_content
      gasoline.carbon_content.should == latest_gasoline_year.carbon_content
    end
  end
end
