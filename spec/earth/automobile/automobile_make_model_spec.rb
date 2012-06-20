require 'spec_helper'
require 'earth/automobile/automobile_make_model'

describe AutomobileMakeModel do
  let(:civic) { AMM.where(:name => "Honda Civic").first }
  let(:civic_years) { AMMY.where(:make_name => 'Honda', :model_name => 'Civic') }
  
  let(:civic_cng) { AMM.where(:name => "Honda Civic CNG").first }
  let(:civic_cng_years) { AMMY.where(:make_name => 'Honda', :model_name => 'Civic CNG') }
  
  let(:f150_ffv) { AMM.where(:name => "Ford F150 FFV").first }
  let(:f150_ffv_years) { AMMY.where(:make_name => 'Ford', :model_name => 'F150 FFV') }
  
  before :all do
    Earth.init :automobile, :load_data_miner => true, :skip_parent_associations => true
    require 'earth/acronyms'
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AMM.run_data_miner!
      AMM.count.should == AMM.connection.select_value("SELECT COUNT(DISTINCT make_name, model_name) FROM #{AMMY.quoted_table_name}")
    end
  end
  
  describe 'verify', :sanity => true do
    it { AMM.where(:fuel_code => nil).count.should == 0 }
    it { AMM.where("fuel_efficiency_city > 0").count.should == AMM.count }
    it { AMM.where("fuel_efficiency_highway > 0").count.should == AMM.count }
    it { AMM.where("alt_fuel_code IS NOT NULL").count.should == 157 }
    it { AMM.where("alt_fuel_efficiency_city > 0").count.should == 157 }
    it { AMM.where("alt_fuel_efficiency_highway > 0").count.should == 157 }
    it { AMM.where(:type_name => nil).count.should == 0 }
    
    # spot checks
    it { civic.fuel_code.should == 'G' }
    it { civic.fuel_efficiency_city.should be_within(1e-4).of(10.884) }
    it { civic.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { civic.fuel_efficiency_highway.should be_within(1e-4).of(14.2857) }
    it { civic.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { civic.alt_fuel_code.should == nil }
    it { civic.alt_fuel_efficiency_city.should == nil }
    it { civic.alt_fuel_efficiency_city_units.should == nil }
    it { civic.alt_fuel_efficiency_highway.should == nil }
    it { civic.alt_fuel_efficiency_highway_units.should == nil }
    
    it { civic.type_name.should == 'Passenger cars' }
    
    it { civic_cng.fuel_code.should == 'C' }
    it { civic_cng.fuel_efficiency_city.should be_within(1e-4).of(10.5237) }
    it { civic_cng.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { civic_cng.fuel_efficiency_highway.should be_within(1e-4).of(14.1971) }
    it { civic_cng.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { f150_ffv.fuel_code.should == 'R' }
    it { f150_ffv.fuel_efficiency_city.should be_within(1e-4).of(5.9628) }
    it { f150_ffv.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { f150_ffv.fuel_efficiency_highway.should be_within(1e-4).of(8.0427) }
    it { f150_ffv.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { f150_ffv.alt_fuel_code.should == 'E' }
    it { f150_ffv.alt_fuel_efficiency_city.should be_within(1e-4).of(4.3744) }
    it { f150_ffv.alt_fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { f150_ffv.alt_fuel_efficiency_highway.should be_within(1e-4).of(5.842) }
    it { f150_ffv.alt_fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { f150_ffv.type_name.should == 'Light-duty trucks' }
  end
  
  describe '.custom_find' do
    it 'considers fuel' do
      %w{ diesel B5 B20 B100 }.each do |fuel|
        AMM.custom_find(
          {
            :make => AutomobileMake.find('Volkswagen'),
            :model => AutomobileModel.find('Jetta'),
            :automobile_fuel => AutomobileFuel.find(fuel)
          }
        ).name.should == 'Volkswagen JETTA DIESEL'
      end
      
      AMM.custom_find(
        {
          :make => AutomobileMake.find('Ford'),
          :model => AutomobileModel.find('F150'),
          :automobile_fuel => AutomobileFuel.find('E85')
        }
      ).name.should == 'Ford F150 FFV'
      
      AMM.custom_find(
        {
          :make => AutomobileMake.find('Honda'),
          :model => AutomobileModel.find('Civic'),
          :automobile_fuel => AutomobileFuel.find('CNG')
        }
      ).name.should == 'Honda CIVIC CNG'
    end
    
    it 'ignores fuel if it does not help' do
      AMM.custom_find(
        {
          :make => AutomobileMake.find('Volkswagen'),
          :model => AutomobileModel.find('Jetta'),
          :automobile_fuel => AutomobileFuel.find('CNG')
        }
      ).name.should == 'Volkswagen JETTA'
    end
  end
  
  describe '#model_years' do
    it { civic.model_years.sort.should == civic_years.sort }
  end
end
