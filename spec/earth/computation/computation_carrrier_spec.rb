require 'spec_helper'
require 'earth/computation/computation_carrier'

describe ComputationCarrier do
  describe 'Sanity check', :sanity => true do
    let(:total) { ComputationCarrier.count }
    
    it { total.should == 1 }
    it { ComputationCarrier.where('power_usage_effectiveness > 1.0').count.should == total }
    
    describe '.fallback' do
      let(:fallback) { ComputationCarrier.fallback }
      
      it { fallback.power_usage_effectiveness.should be_within(5e-3).of(1.5) }
    end
  end
end
