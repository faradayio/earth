require 'spec_helper'
require 'earth/automobile/automobile_make_model'

describe AutomobileMakeModel do
  before :all do
    Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => :true
    AMM = AutomobileMakeModel
    
    @civic = AMM.find "Honda Civic"
    @civic_cng = AMM.find "Honda Civic CNG"
    @f150_ffv = AMM.find "Ford F150 FFV"
    
    @civic_years = AutomobileMakeModelYear.where(:make_name => 'Honda', :model_name => 'Civic')
    @civic_cng_years = AutomobileMakeModelYear.where(:make_name => 'Honda', :model_name => 'Civic CNG')
    @f150_ffv_years = AutomobileMakeModelYear.where(:make_name => 'Ford', :model_name => 'F150 FFV')
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AMM.run_data_miner!
      AMM.count.should == AMM.connection.select_value("SELECT COUNT(DISTINCT make_name, model_name) FROM #{AutomobileMakeModelYear.quoted_table_name}")
    end
  end
  
  describe '#model_years' do
    it { @civic.model_years.sort.should == @civic_years.sort }
  end
  
  describe '#fuel_code' do
    it { @civic.fuel_code.should == 'G' }
    it { @civic_cng.fuel_code.should == 'C' }
    it { @f150_ffv.fuel_code.should == 'R' }
  end
  
  describe '#fuel_efficiency_city' do
    it { @civic.fuel_efficiency_city.should_not == nil }
    it { @civic.fuel_efficiency_city.should == @civic_years.weighted_average(:fuel_efficiency_city) }
    
    it { @civic_cng.fuel_efficiency_city.should_not == nil }
    it { @civic_cng.fuel_efficiency_city.should == @civic_cng_years.weighted_average(:fuel_efficiency_city) }
    
    it { @f150_ffv.fuel_efficiency_city.should_not == nil }
    it { @f150_ffv.fuel_efficiency_city.should == @f150_ffv_years.weighted_average(:fuel_efficiency_city) }
  end
  
  describe '#fuel_efficiency_city_units' do
    it { @civic.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { @civic_cng.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { @f150_ffv.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
  end
  
  describe '#fuel_efficiency_highway' do
    it { @civic.fuel_efficiency_highway.should_not == nil }
    it { @civic.fuel_efficiency_highway.should == @civic_years.weighted_average(:fuel_efficiency_highway) }
    
    it { @civic_cng.fuel_efficiency_highway.should_not == nil }
    it { @civic_cng.fuel_efficiency_highway.should == @civic_cng_years.weighted_average(:fuel_efficiency_highway) }
    
    it { @f150_ffv.fuel_efficiency_highway.should_not == nil }
    it { @f150_ffv.fuel_efficiency_highway.should == @f150_ffv_years.weighted_average(:fuel_efficiency_highway) }
  end
  
  describe '#fuel_efficiency_highway_units' do
    it { @civic.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    it { @civic_cng.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    it { @f150_ffv.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
  end
  
  describe '#alt_fuel_code' do
    it { @civic.alt_fuel_code.should == nil }
    it { @civic_cng.alt_fuel_code.should == nil }
    it { @f150_ffv.alt_fuel_code.should == 'E' }
  end
  
  describe '#alt_fuel_efficiency_city' do
    it { @civic.alt_fuel_efficiency_city.should == nil }
    it { @civic_cng.alt_fuel_efficiency_city.should == nil }
    
    it { @f150_ffv.alt_fuel_efficiency_city.should_not == nil }
    it { @f150_ffv.alt_fuel_efficiency_city.should == @f150_ffv_years.weighted_average(:alt_fuel_efficiency_city) }
  end
  
  describe '#fuel_efficiency_city_units' do
    it { @civic.alt_fuel_efficiency_city_units.should == nil }
    it { @civic_cng.alt_fuel_efficiency_city_units.should == nil }
    it { @f150_ffv.alt_fuel_efficiency_city_units.should == 'kilometres_per_litre' }
  end
  
  describe '#alt_fuel_efficiency_highway' do
    it { @civic.alt_fuel_efficiency_highway.should == nil }
    it { @civic_cng.alt_fuel_efficiency_highway.should == nil }
    
    it { @f150_ffv.alt_fuel_efficiency_highway.should_not == nil }
    it { @f150_ffv.alt_fuel_efficiency_highway.should == @f150_ffv_years.weighted_average(:alt_fuel_efficiency_highway) }
  end
  
  describe '#fuel_efficiency_highway_units' do
    it { @civic.alt_fuel_efficiency_highway_units.should == nil }
    it { @civic_cng.alt_fuel_efficiency_highway_units.should == nil }
    it { @f150_ffv.alt_fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
  end
end
