require 'spec_helper'
require "#{Earth::FACTORY_DIR}/greenhouse_gas"

describe GreenhouseGas do
  describe '.[abbreviation]' do
    it {
      GreenhouseGas.delete_all
      co2 = FactoryGirl.create :ghg, :co2
      GreenhouseGas['co2'].should == co2
    }
  end
  
  describe 'Sanity check', :sanity => true do
    let(:total) { GreenhouseGas.count }
    
    it { total.should == 4 }
    it { GreenhouseGas.where('abbreviation IS NOT NULL').count.should == total }
    it { GreenhouseGas.where('ipcc_report IS NOT NULL').count.should == total }
    it { GreenhouseGas.where(:time_horizon => 100).count.should == total }
    it { GreenhouseGas.where(:time_horizon_units => 'years').count.should == total }
    it { GreenhouseGas.where('global_warming_potential >= 1').count.should == total }
  end
end
