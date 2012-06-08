require 'spec_helper'
require 'earth/automobile/automobile_make_model'
require 'earth/automobile/automobile_make_model_year' # needed for some tests

describe AutomobileMakeModel do
  let(:civic) { AMM.where(:name => "Honda Civic").first }
  let(:civic_years) { AMMY.where(:make_name => 'Honda', :model_name => 'Civic') }
  
  let(:civic_cng) { AMM.where(:name => "Honda Civic CNG").first }
  let(:civic_cng_years) { AMMY.where(:make_name => 'Honda', :model_name => 'Civic CNG') }
  
  let(:f150_ffv) { AMM.where(:name => "Ford F150 FFV").first }
  let(:f150_ffv_years) { AMMY.where(:make_name => 'Ford', :model_name => 'F150 FFV') }
  
  before :all do
    Earth.init :automobile, :load_data_miner => true
    require 'earth/acronyms'
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AMM.run_data_miner!
      AMM.count.should == AMM.connection.select_value("SELECT COUNT(DISTINCT make_name, model_name) FROM #{AutomobileMakeModelYear.quoted_table_name}")
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
    it { civic.automobile_fuel.should == AutomobileFuel.gasoline }
    it { civic.fuel_efficiency_city.should be_within(1e-4).of(10.884) }
    it { civic.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { civic.fuel_efficiency_highway.should be_within(1e-4).of(14.2857) }
    it { civic.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { civic.alt_automobile_fuel.should == nil }
    it { civic.alt_fuel_efficiency_city.should == nil }
    it { civic.alt_fuel_efficiency_city_units.should == nil }
    it { civic.alt_fuel_efficiency_highway.should == nil }
    it { civic.alt_fuel_efficiency_highway_units.should == nil }
    
    it { civic.type_name.should == 'Passenger cars' }
    
    it { civic_cng.automobile_fuel.should == AutomobileFuel.find('cng') }
    it { civic_cng.fuel_efficiency_city.should be_within(1e-4).of(10.5237) }
    it { civic_cng.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { civic_cng.fuel_efficiency_highway.should be_within(1e-4).of(14.1971) }
    it { civic_cng.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { f150_ffv.automobile_fuel.should == AutomobileFuel.find('regular gasoline') }
    it { f150_ffv.fuel_efficiency_city.should be_within(1e-4).of(5.9628) }
    it { f150_ffv.fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { f150_ffv.fuel_efficiency_highway.should be_within(1e-4).of(8.0427) }
    it { f150_ffv.fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { f150_ffv.alt_automobile_fuel.should == AutomobileFuel.find('E85') }
    it { f150_ffv.alt_fuel_efficiency_city.should be_within(1e-4).of(4.3744) }
    it { f150_ffv.alt_fuel_efficiency_city_units.should == 'kilometres_per_litre' }
    it { f150_ffv.alt_fuel_efficiency_highway.should be_within(1e-4).of(5.842) }
    it { f150_ffv.alt_fuel_efficiency_highway_units.should == 'kilometres_per_litre' }
    
    it { f150_ffv.type_name.should == 'Light-duty trucks' }
  end
  
  describe '#model_years' do
    it { civic.model_years.sort.should == civic_years.sort }
  end
end
