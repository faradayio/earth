require 'spec_helper'
require "#{Earth::FACTORY_DIR}/automobile_type_fuel_year"

describe AutomobileTypeFuelYear, :data_miner => true do
  let(:atfy) { AutomobileTypeFuelYear } 
  
  describe '.find_by_type_name_and_fuel_family_and_closest_year' do
    it "should return the ATFY from the closest year" do
      atfy.delete_all
      car_1984 = FactoryGirl.create :atfy, :car_1984
      car_2009 = FactoryGirl.create :atfy, :car_2009
      car_2011 = FactoryGirl.create :atfy, :car_2011
      
      atfy.find_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 1970).should == car_1984
      atfy.find_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 2009).should == car_2009
      atfy.find_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 2012).should == car_2011
    end
  end
  
  describe '#type_fuel_year_controls' do
    it "should find controls from 1985 when year < 1985" do
      atfy.delete_all
      FactoryGirl.create(:atfy, :car_1984).type_fuel_year_controls.first.year.should == 1985
    end
    
    it "should find controls from year when year from 1985 to 2010" do
      atfy.delete_all
      FactoryGirl.create(:atfy, :car_2009).type_fuel_year_controls.first.year.should == 2009
    end
    
    it "should find controls from 2010 when year > 2010" do
      atfy.delete_all
      FactoryGirl.create(:atfy, :car_2011).type_fuel_year_controls.first.year.should == 2010
    end
  end
  
  describe 'Sanity check', :sanity => true do
    let(:test_atfy) { atfy.where(:type_name => 'Passenger cars', :fuel_family => 'gasoline', :year => 2005).first }
    
    it { atfy.count.should == 124 }
    
    it 'shares should sum to 1' do
      atfy.sum(:share_of_type, :group => [:type_name, :fuel_family]).each do |groupers, total|
        total.should be_within(1e-2).of(1.0)
      end
    end
    
    it { atfy.where("annual_distance > 0").count.should == atfy.count }
    it { atfy.where("ch4_emission_factor > 0").count.should == atfy.count }
    it { atfy.where("n2o_emission_factor > 0").count.should == atfy.count }
    
    # spot checks
    it { test_atfy.annual_distance.should be_within(0.05).of(19598.6) }
    it { test_atfy.annual_distance_units.should == 'kilometres' }
    it { test_atfy.ch4_emission_factor.should be_within(5e-7).of(0.000229) }
    it { test_atfy.ch4_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
    it { test_atfy.n2o_emission_factor.should be_within(5e-6).of(0.00147) }
    it { test_atfy.n2o_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
  end
end
