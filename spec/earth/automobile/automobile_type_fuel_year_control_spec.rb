require 'spec_helper'
require "#{Earth::FACTORY_DIR}/automobile_type_fuel_control"
require "#{Earth::FACTORY_DIR}/automobile_type_fuel_year_control"

describe AutomobileTypeFuelYearControl do
  let(:atfyc) { AutomobileTypeFuelYearControl }
  
  describe '.find_all_by_type_name_and_fuel_family_and_closest_year' do
    it "should return all ATFYCs from the closest year" do
      atfyc.delete_all
      car_2009_1 = FactoryGirl.create :atfyc, :car_2009_1
      car_2009_2 = FactoryGirl.create :atfyc, :car_2009_2
      car_2010_1 = FactoryGirl.create :atfyc, :car_2010_1
      car_2010_2 = FactoryGirl.create :atfyc, :car_2010_2
      
      atfyc.find_all_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 2011).should == [car_2010_1, car_2010_2]
      atfyc.find_all_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 2009).should == [car_2009_1, car_2009_2]
      atfyc.find_all_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 2005).should == [car_2009_1, car_2009_2]
    end
  end
  
  describe '#ch4_emission_factor' do
    it { 
      FactoryGirl.create :atfc, :car_tier_1
      car_2010_1 = FactoryGirl.create :atfyc, :car_2010_1
      
      car_2010_1.ch4_emission_factor.should be_within(5e-3).of(0.04)
      car_2010_1.ch4_emission_factor_units.should == 'kilograms_co2e_per_kilometre'
    }
  end
  
  describe '#n2o_emission_factor' do
    it { 
      FactoryGirl.create :atfc, :car_tier_1
      car_2010_1 = FactoryGirl.create :atfyc, :car_2010_1
      
      car_2010_1.n2o_emission_factor.should be_within(5e-3).of(0.08)
      car_2010_1.n2o_emission_factor_units.should == 'kilograms_co2e_per_kilometre'
    }
  end
  
  describe 'Sanity check', :sanity => true do
    it { atfyc.count.should == 142 }
    
    it 'total travel percent should sum to 1' do
      atfyc.group([:type_name, :fuel_family, :year]).sum(:total_travel_percent).each do |grouping_criteria, total|
        total.should be_within(1e-5).of(1.0)
      end
    end
    
    it { atfyc.where(:type_fuel_control_name => nil).count.should == 0 }
  end
end
