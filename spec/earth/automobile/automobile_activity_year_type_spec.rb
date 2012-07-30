require 'spec_helper'
require 'earth/automobile/automobile_activity_year_type'

describe AutomobileActivityYearType do
  before :all do
    require 'earth/acronyms'
  end
  
  describe 'verify', :sanity => true do
    it { AAYT.count.should == 30 }
    it { AAYT.where("hfc_emissions > 0").count.should == AAYT.count }
    it { AAYT.where("hfc_emission_factor > 0").count.should == AAYT.count }
    
    # spot check
    it { AAYT.first.hfc_emissions.should be_within(0.1).of(31000000000) }
    it { AAYT.first.hfc_emission_factor.should be_within(1e-5).of(0.02438) }
    it { AAYT.first.hfc_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
  end
  
  describe '.find_by_type_name_and_closest_year' do
    it { AAYT.find_by_type_name_and_closest_year('Passenger cars', 2010).should == AAYT.where(:type_name => 'Passenger cars', :activity_year => 2009).first }
    it { AAYT.find_by_type_name_and_closest_year('Passenger cars', 2005).should == AAYT.where(:type_name => 'Passenger cars', :activity_year => 2005).first }
    it { AAYT.find_by_type_name_and_closest_year('Passenger cars', 1994).should == AAYT.where(:type_name => 'Passenger cars', :activity_year => 1995).first }
  end
  
  describe '#activity_year_type_fuels' do
    it 'should match' do
      AAYT.first.activity_year_type_fuels.should == AAYTF.where(:activity_year => 1995, :type_name => 'Light-duty trucks')
    end
  end
end
