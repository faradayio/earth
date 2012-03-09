require 'spec_helper'
require 'earth/fuel/fuel'
require 'earth/fuel/fuel/data_miner'
require 'earth/fuel/fuel_year'

describe Fuel do
  before :all do
    Fuel.auto_upgrade!
  end
  
  describe 'when importing data', :data_miner => true do
    it 'fetches all fuels' do
      Earth.init :fuel, :load_data_miner => true
      Fuel.run_data_miner!
      Fuel.count.should == 22
    end
  end
  
  describe 'after importing data', :sanity => true do
    it 'should have a record for district heat' do
      district_heat = Fuel.find 'District Heat'
      district_heat.co2_emission_factor.should be_within(0.00001).of(0.0766528)
    end
    
    # TODO is there a way to check whether the value in the fuels table is NULL?
    it 'should check FuelYear for any missing values' do
      Earth.init :fuel_year
      gasoline = Fuel.find('Motor Gasoline')
      gasoline_years = FuelYear.where(:fuel_name => 'Motor Gasoline')
      latest_gasoline_year = gasoline_years.find_by_year(gasoline_years.maximum(:year))
      gasoline.energy_content.should == latest_gasoline_year.energy_content
      gasoline.carbon_content.should == latest_gasoline_year.carbon_content
    end
  end
end
