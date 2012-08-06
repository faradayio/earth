require 'spec_helper'
require 'earth/residence/clothes_machine_use'

describe ClothesMachineUse do
  describe "Sanity check", :sanity => true do
    it { ClothesMachineUse.count.should == 5 }
    
    # spot check
    it { ClothesMachineUse.first.annual_energy_from_electricity_for_clothes_driers.should == 2087260000 }
  end
end
