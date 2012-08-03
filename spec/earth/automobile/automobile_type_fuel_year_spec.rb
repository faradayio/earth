require 'spec_helper'
require "#{Earth::FACTORY_DIR}/automobile_type_fuel_year"
require "#{Earth::FACTORY_DIR}/automobile_type_fuel_year_control"

describe AutomobileTypeFuelYear, :data_miner => true do
  let(:atfy) { AutomobileTypeFuelYear } 
  
  describe '.find_by_type_name_and_fuel_family_and_closest_year' do
    it "should return the ATFY from the closest year" do
      cars_1984 = FactoryGirl.create :atfy, :cars_1984
      cars_2009 = FactoryGirl.create :atfy, :cars_2009
      cars_2011 = FactoryGirl.create :atfy, :cars_2011
      
      atfy.find_by_type_name_and_fuel_family_and_closest_year('cars', 'gas', 1970).should == cars_1984
      atfy.find_by_type_name_and_fuel_family_and_closest_year('cars', 'gas', 2009).should == cars_2009
      atfy.find_by_type_name_and_fuel_family_and_closest_year('cars', 'gas', 2012).should == cars_2011
    end
  end
  
  describe '#type_fuel_year_controls' do
    it "should return the controls from the closest year" do
      FactoryGirl.create :atfyc, :cars_1985_1
      FactoryGirl.create :atfyc, :cars_2009_1
      FactoryGirl.create :atfyc, :cars_2009_2
      FactoryGirl.create :atfyc, :cars_2010_1
      FactoryGirl.create :atfyc, :cars_2010_2
      
      FactoryGirl.create(:atfy, :cars_1984).type_fuel_year_controls.first.year.should == 1985
      FactoryGirl.create(:atfy, :cars_2009).type_fuel_year_controls.first.year.should == 2009
      FactoryGirl.create(:atfy, :cars_2011).type_fuel_year_controls.first.year.should == 2010
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
