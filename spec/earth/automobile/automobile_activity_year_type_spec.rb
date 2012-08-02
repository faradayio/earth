require 'spec_helper'
require "#{Earth::FACTORY_DIR}/automobile_activity_year_type"
require "#{Earth::FACTORY_DIR}/automobile_activity_year_type_fuel"

describe AutomobileActivityYearType do
  let(:aayt) { AutomobileActivityYearType }
  
  describe '.find_by_type_name_and_closest_year' do
    it 'returns the AAYT with the closest year' do
      aayt.delete_all
      
      car_2009 = FactoryGirl.create :aayt, :car_2009
      car_2010 = FactoryGirl.create :aayt, :car_2010
      
      aayt.find_by_type_name_and_closest_year('Passenger cars', 2011).should == car_2010
      aayt.find_by_type_name_and_closest_year('Passenger cars', 2009).should == car_2009
      aayt.find_by_type_name_and_closest_year('Passenger cars', 2000).should == car_2009
    end
  end
  
  describe '#activity_year_type_fuels' do
    it 'returns activity year type fuels with the same activity year and type name' do
      d = FactoryGirl.create :aaytf, :diesel_car_2010
      g = FactoryGirl.create :aaytf, :gas_car_2010
      car_2010 = FactoryGirl.create :aayt, :car_2010
      car_2010.activity_year_type_fuels.should == [d,g]
    end
  end
  
  describe 'Sanity check', :sanity => true do
    let(:total) { aayt.count }
    it { total.should == 30 }
    it { aayt.where("hfc_emissions > 0").count.should == total }
    it { aayt.where("hfc_emission_factor > 0").count.should == total }
    
    # spot check
    it { aayt.first.hfc_emissions.should be_within(0.1).of(31000000000) }
    it { aayt.first.hfc_emission_factor.should be_within(1e-5).of(0.02438) }
    it { aayt.first.hfc_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
  end
end
