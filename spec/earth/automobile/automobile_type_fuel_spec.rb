require 'spec_helper'
require 'earth/automobile/automobile_type_fuel'

describe AutomobileTypeFuel do
  let(:test_type_fuel) { AutomobileTypeFuel.find('Light-duty trucks gasoline') }
  
  before :all do
    Earth.init :automobile, :load_data_miner => true
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AutomobileTypeFuel.run_data_miner!
    end
  end
  
  describe 'verify', :sanity => true do
    it { AutomobileTypeFuel.count.should == 4 }
    it { AutomobileTypeFuel.where("annual_distance > 0").count.should == AutomobileTypeFuel.count }
    it { AutomobileTypeFuel.where("ch4_emission_factor > 0").count.should == AutomobileTypeFuel.count }
    it { AutomobileTypeFuel.where("n2o_emission_factor > 0").count.should == AutomobileTypeFuel.count }
    it { AutomobileTypeFuel.where("vehicles > 0").count.should == AutomobileTypeFuel.count }
    
    # spot checks
    it { test_type_fuel.annual_distance.should be_within(0.1).of(19626.6) }
    it { test_type_fuel.annual_distance_units.should == 'kilometres' }
    it { test_type_fuel.ch4_emission_factor.should be_within(1e-8).of(5.0749e-4) }
    it { test_type_fuel.ch4_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
    it { test_type_fuel.n2o_emission_factor.should be_within(1e-7).of(7.4864e-3) }
    it { test_type_fuel.n2o_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
    it { test_type_fuel.vehicles.should be_within(50).of(87_877_167) }
    it { test_type_fuel.fuel_consumption.should be_within(1).of(129_881_000_000) }
    it { test_type_fuel.fuel_consumption_units.should == 'litres' }
  end
  
  describe '#latest_activity_year_type_fuel' do
    it 'should always be a match from 2009' do
      AutomobileTypeFuel.safe_find_each do |atf|
        atf.latest_activity_year_type_fuel.type_name.should == atf.type_name
        atf.latest_activity_year_type_fuel.fuel_family.should == atf.fuel_family
        atf.latest_activity_year_type_fuel.activity_year.should == 2009
      end
    end
  end
end
