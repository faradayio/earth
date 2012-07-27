require 'spec_helper'
require 'earth/automobile/automobile_type_fuel_year'

describe AutomobileTypeFuelYear, :data_miner => true do
  let(:test_atfy) { ATFY.where(:type_name => 'Passenger cars', :fuel_family => 'gasoline', :year => 2005).first }
  
  before :all do
    Earth.init :automobile, :load_data_miner => true
    require 'earth/acronyms'
  end
  
  describe 'import' do
    it 'should import data' do
      ATFY.run_data_miner!
    end
  end
  
  describe 'verify', :sanity => true do
    it { ATFY.count.should == 124 }
    
    it 'shares should sum to 1' do
      ATFY.sum(:share_of_type, :group => [:type_name, :fuel_family]).each do |groupers, total|
        total.should be_within(1e-2).of(1.0)
      end
    end
    
    it { ATFY.where("annual_distance > 0").count.should == ATFY.count }
    it { ATFY.where("ch4_emission_factor > 0").count.should == ATFY.count }
    it { ATFY.where("n2o_emission_factor > 0").count.should == ATFY.count }
    
    # spot checks
    it { test_atfy.annual_distance.should be_within(0.05).of(19598.6) }
    it { test_atfy.annual_distance_units.should == 'kilometres' }
    it { test_atfy.ch4_emission_factor.should be_within(5e-7).of(0.000229) }
    it { test_atfy.ch4_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
    it { test_atfy.n2o_emission_factor.should be_within(5e-6).of(0.00147) }
    it { test_atfy.n2o_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
  end
  
  describe '.find_by_type_name_and_fuel_family_and_closest_year' do
    it { ATFY.find_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 1970).should == ATFY.find_by_type_name_and_fuel_family_and_year('Passenger cars', 'gasoline', 1979) }
    it { ATFY.find_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 2005).should == ATFY.find_by_type_name_and_fuel_family_and_year('Passenger cars', 'gasoline', 2005) }
    it { ATFY.find_by_type_name_and_fuel_family_and_closest_year('Passenger cars', 'gasoline', 2012).should == ATFY.find_by_type_name_and_fuel_family_and_year('Passenger cars', 'gasoline', 2009) }
  end
  
  describe '#type_fuel_year_controls' do
    it "should find controls from 1985 when year < 1985" do
      ATFY.where("year < 1985").each do |atfy|
        atfy.type_fuel_year_controls.first.year.should == 1985
      end
    end
    
    it "should find controls from year when year from 1985 to 2010" do
      ATFY.where("year >= 1985 AND year <= 2010").each do |atfy|
        atfy.type_fuel_year_controls.first.year.should == atfy.year
      end
    end
    
    it "should find controls from 2010 when year > 2010" do
      ATFY.where("year > 2010").each do |atfy|
        atfy.type_fuel_year_controls.first.year.should == 2010
      end
    end
  end
end
