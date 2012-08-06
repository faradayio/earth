require 'spec_helper'
require 'earth/shipping/shipment_mode'

describe ShipmentMode do
  describe "Sanity check", :sanity => true do
    let(:total) { ShipmentMode.count }
    
    it { total.should == 3 }
    it { ShipmentMode.where('route_inefficiency_factor >= 1').count.should == total }
    it { ShipmentMode.where('transport_emission_factor > 0').count.should == total }
    
    # spot check
    it { ShipmentMode.first.route_inefficiency_factor.should == 1.1 }
    it { ShipmentMode.first.transport_emission_factor.should be_within(5e-7).of(0.001586) }
  end
end
