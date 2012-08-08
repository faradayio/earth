require 'spec_helper'
require 'earth/shipping/carrier'

describe Carrier do
  describe "Sanity check", :sanity => true do
    let(:total) { Carrier.count }
    
    it { total.should == 3 }
    it { Carrier.where('package_volume > 0').count.should == total }
    it { Carrier.where('route_inefficiency_factor >= 1').count.should == total }
    it { Carrier.where('transport_emission_factor > 0').count.should == total }
    it { Carrier.where('corporate_emission_factor > 0').count.should == total }
    
    # spot check
    it { Carrier.first.package_volume.should == 2467960000 }
    it { Carrier.first.route_inefficiency_factor.should == 1.05 }
    it { Carrier.first.transport_emission_factor.should be_within(5e-7).of(0.000781) }
    it { Carrier.first.corporate_emission_factor.should == 0.327 }
    
    describe '.fallback' do
      let(:fallback) { Carrier.fallback }
      it { fallback.route_inefficiency_factor.should == 1.03 }
      it { fallback.transport_emission_factor.should be_within(5e-7).of(0.000527) }
      it { fallback.corporate_emission_factor.should == 0.221 }
    end
  end
end
