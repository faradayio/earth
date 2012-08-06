require 'spec_helper'
require 'earth/residence/residence_fuel_price'

describe ResidenceFuelPrice do
  describe "Sanity check", :sanity => true do
    it { ResidenceFuelPrice.count.should == 13741 }
    
    # spot check
    let(:ca_elec) { ResidenceFuelPrice.where(:year => 2012, :month => 5, :residence_fuel_type_name => 'electricity', :locatable_id => 'CA').first }
    it { ca_elec.price.should == 0.1517 }
  end
end
