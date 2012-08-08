require 'spec_helper'
require 'earth/automobile/automobile_make'

describe AutomobileMake do
  describe 'Sanity check', :sanity => true do
    let(:total) { AutomobileMake.count }
    
    it { total.should == 81 }
    it { AutomobileMake.where("fuel_efficiency > 0").count.should == total }
    it { AutomobileMake.where(:fuel_efficiency_units => 'kilometres_per_litre').count.should == total }
    
    # spot checks
    it { AutomobileMake.find('Honda').fuel_efficiency.should be_within(1e-4).of(13.0594) } # fe from CAFE data
    it { AutomobileMake.find('Acura').fuel_efficiency.should be_within(1e-4).of(9.1347) }  # fe from average of variants
  end
end
