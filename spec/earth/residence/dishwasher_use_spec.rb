require 'spec_helper'
require 'earth/residence/dishwasher_use'

describe DishwasherUse do
  describe "Sanity check", :sanity => true do
    it { DishwasherUse.count.should == 5 }
    
    # spot check
    it { DishwasherUse.first.annual_energy_from_electricity_for_dishwashers.should == 669100000 }
  end
end
