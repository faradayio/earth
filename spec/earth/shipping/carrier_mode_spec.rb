require 'spec_helper'
require 'earth/shipping/carrier_mode'

describe CarrierMode do
  describe "Sanity check", :sanity => true do
    let(:total) { CarrierMode.count }
    
    it { total.should == 9 }
    it { CarrierMode.where('package_volume > 0').count.should == total }
    it { CarrierMode.where('route_inefficiency_factor >= 1').count.should == total }
    it { CarrierMode.where('transport_emission_factor > 0').count.should == total }
    
    # spot check
    it { CarrierMode.first.package_volume.should == 1257980000 }
    it { CarrierMode.first.route_inefficiency_factor.should == 1.1 }
    it { CarrierMode.first.transport_emission_factor.should be_within(5e-7).of(0.001348) }
  end
end
