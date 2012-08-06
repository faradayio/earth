require 'spec_helper'
require 'earth/computation/computation_carrier_instance_class'

describe ComputationCarrierInstanceClass do
  describe 'Sanity check', :sanity => true do
    let(:ccic) { ComputationCarrierInstanceClass }
    let(:total) { ccic.count }
    
    it { total.should == 8 }
    it { ccic.where('electricity_intensity > 0').count.should == total }
    
    describe '.fallback' do
      let(:fallback) { ccic.fallback }
      it { fallback.electricity_intensity.should be_within(5e-6).of(0.105) }
    end
  end
end
