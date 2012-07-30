require 'spec_helper'
require 'earth/automobile/automobile_make'

describe AutomobileMake do
  let(:honda) { AutomobileMake.find('Honda') } # MakeYear with fe from CAFE data
  let(:acura) { AutomobileMake.find('Acura') } # MakeYear with fe from average of variants
  
  describe 'verify', :sanity => true do
    it { AutomobileMake.where("fuel_efficiency > 0").count.should == AutomobileMake.count }
    it { AutomobileMake.where(:fuel_efficiency_units => 'kilometres_per_litre').count.should == AutomobileMake.count }
    
    # spot checks
    it { honda.fuel_efficiency.should be_within(1e-4).of(13.0594) }
    it { acura.fuel_efficiency.should be_within(1e-4).of(9.1347) }
  end
end
