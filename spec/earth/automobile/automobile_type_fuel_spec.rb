require 'spec_helper'
require "#{Earth::FACTORY_DIR}/automobile_type_fuel"
require "#{Earth::FACTORY_DIR}/automobile_activity_year_type_fuel"

describe AutomobileTypeFuel do
  let(:atf) { AutomobileTypeFuel }
  let(:aaytf) { AutomobileActivityYearTypeFuel }
  
  describe '#latest_activity_year_type_fuel' do
    it 'should always be a match from the latest activity year' do
      FactoryGirl.create :aaytf, :gas_car_2009
      FactoryGirl.create :aaytf, :gas_car_2010
      car_gas = FactoryGirl.create :atf, :car_gas
      latest_year = aaytf.maximum :activity_year
      car_gas.latest_activity_year_type_fuel.activity_year.should == latest_year
    end
  end
  
  describe 'Sanity check', :sanity => true do
    let(:total) { atf.count }
    let(:test_type_fuel) { AutomobileTypeFuel.find('Light-duty trucks gasoline') }
    
    it { total.should == 4 }
    it { atf.where("annual_distance > 0").count.should == total }
    it { atf.where("ch4_emission_factor > 0").count.should == total }
    it { atf.where("n2o_emission_factor > 0").count.should == total }
    it { atf.where("vehicles > 0").count.should == total }
    
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
end
