require 'spec_helper'
require 'earth/automobile/automobile_type_fuel_year_control'

describe AutomobileTypeFuelYearControl do
  let(:test_year_control) { ATFYC.where(:type_name => 'Passenger cars', :fuel_family => 'gasoline', :year => 2005).first }
  
  before :all do
    require 'earth/acronyms'
  end
  
  describe 'verify imported data', :sanity => true do
    it { ATFYC.count.should == 142 }
    
    it 'total travel percent should sum to 1' do
      ATFYC.group([:type_name, :fuel_family, :year]).sum(:total_travel_percent).each do |grouping_criteria, total|
        total.should be_within(1e-5).of(1.0)
      end
    end
    
    it { ATFYC.where(:type_fuel_control_name => nil).count.should == 0 }
  end
  
  describe '.find_all_by_type_name_and_fuel_family_and_closest_year' do
    it { ATFYC.find_all_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 1980).should == ATFYC.find_all_by_type_name_and_fuel_family_and_year('Passenger cars', 'gasoline', 1985) }
    it { ATFYC.find_all_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 2005).should == ATFYC.find_all_by_type_name_and_fuel_family_and_year('Passenger cars', 'gasoline', 2005) }
    it { ATFYC.find_all_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 2012).should == ATFYC.find_all_by_type_name_and_fuel_family_and_year('Passenger cars', 'gasoline', 2010) }
  end
  
  describe '#ch4_emission_factor' do
    it { test_year_control.ch4_emission_factor.should be_within(1e-10).of(2.68743e-4) }
  end
  
  describe '#ch4_emission_factor_units' do
    it { test_year_control.ch4_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
  end
  
  describe '#n2o_emission_factor' do
    it { test_year_control.n2o_emission_factor.should be_within(1e-10).of(6.66607e-4) }
  end
  
  describe '#n2o_emission_factor_units' do
    it { test_year_control.n2o_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
  end
end
