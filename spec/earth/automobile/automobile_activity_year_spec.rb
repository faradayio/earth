require 'spec_helper'
require "#{Earth::FACTORY_DIR}/automobile_activity_year"

describe AutomobileActivityYear do
  let(:aay) { AutomobileActivityYear }
  
  describe '.find_by_closest_year' do
    it "returns the closest year" do
      aay.delete_all
      twenty_nine = FactoryGirl.create :aay, :twenty_nine
      twenty_ten = FactoryGirl.create :aay, :twenty_ten
      
      aay.find_by_closest_year(2011).should == twenty_ten
      aay.find_by_closest_year(2009).should == twenty_nine
      aay.find_by_closest_year(2005).should == twenty_nine
    end
  end
  
  describe 'Sanity check', :sanity => true do
    let(:total) { aay.count }
    
    it { total.should == 15 }
    it { aay.where("hfc_emission_factor > 0").count.should == total }
    
    # spot check
    it { aay.first.hfc_emission_factor.should be_within(1e-5).of(0.01656) }
    it { aay.first.hfc_emission_factor_units.should == 'kilograms_co2e_per_kilometre' }
  end
end
