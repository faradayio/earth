require 'spec_helper'
require 'earth/bus/bus_fuel_year_control'

describe BusFuelYearControl do
  describe 'Sanity check', :sanity => true do
    it { BusFuelYearControl.count.should == 67 }
    it 'total travel percent should sum to 1' do
      BusFuelYearControl.group([:bus_fuel_name, :year]).sum(:total_travel_percent).each do |grouping_criteria, total|
        total.should be_within(5e-2).of(1.0)
      end
    end
  end
end
