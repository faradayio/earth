require 'spec_helper'
require 'earth/locality/climate_division_month'

describe ClimateDivisionMonth do
  let(:cdm) { ClimateDivisionMonth }
  
  describe 'Sanity check', :sanity => true do
    let(:total) { 344 * (((Date.today.year - 2011) * 12) + Date.today.prev_month.month) }
    let(:test_month) { cdm.find('VT3-2012-9') }
    
    it { cdm.count.should == total }
    it { cdm.where('year < 2011').count.should == 0 }
    it { cdm.where('month < 0 OR month > 12').count.should == 0 }
    it { cdm.where('heating_degree_days < 0').count.should == 0 }
    it { cdm.where('cooling_degree_days < 0').count.should == 0 }
    
    # spot check
    it { test_month.heating_degree_days.should be_within(5e-4).of(131.111) }
    it { test_month.heating_degree_days_units.should == 'degrees_celsius' }
    it { test_month.cooling_degree_days.should be_within(5e-6).of(2.77778) }
    it { test_month.cooling_degree_days_units.should == 'degrees_celsius' }
  end
end
