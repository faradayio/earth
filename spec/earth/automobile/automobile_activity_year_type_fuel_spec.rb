require 'spec_helper'
require "#{Earth::FACTORY_DIR}/automobile_activity_year_type_fuel"

describe AutomobileActivityYearTypeFuel do
  let(:aaytf) { AutomobileActivityYearTypeFuel }
  
  describe '.latest' do
    it "returns all records from the latest year" do
      aaytf.delete_all
      
      FactoryGirl.create :aaytf, :gas_car_2009
      d = FactoryGirl.create :aaytf, :diesel_car_2010
      g = FactoryGirl.create :aaytf, :gas_car_2010
      
      aaytf.latest.should == [d, g]
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { aaytf.count.should == 120 }
    it { aaytf.where(:distance => nil).count.should == 0 }
    it { aaytf.where("fuel_family != 'alternative' AND fuel_consumption IS NULL").count.should == 0 }
  end
end
