require 'spec_helper'
require 'earth/fuel/fuel'
require 'earth/fuel/fuel_year' # methods are delegated to FuelYear if value in fuels is null

describe Fuel do
  describe 'when importing data', :data_miner => true do
    before do
      Earth.init :fuel, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it 'fetches all fuels' do
      Fuel.run_data_miner!
    end
  end
  
  describe 'after importing data', :sanity => true do
    it 'should have all the data' do
      Fuel.count.should == 23
    end
    
    it 'should have a record for district heat' do
      district_heat = Fuel.find 'District Heat'
      district_heat.co2_emission_factor.should be_within(0.00001).of(0.0766528)
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
