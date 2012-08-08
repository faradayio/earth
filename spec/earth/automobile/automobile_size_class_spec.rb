require 'spec_helper'
require 'earth/automobile/automobile_size_class'

describe AutomobileSizeClass do
  describe 'Sanity check', :sanity => true do
    let(:total) { AutomobileSizeClass.count }
    it { total.should == 15 }
    it { AutomobileSizeClass.where("fuel_efficiency_city > 0").count.should == total }
    it { AutomobileSizeClass.where("fuel_efficiency_highway > 0").count.should == total }
    it { AutomobileSizeClass.where("hybrid_fuel_efficiency_city_multiplier > 1.0").count.should == 7 }
    it { AutomobileSizeClass.where("hybrid_fuel_efficiency_highway_multiplier > 1.0").count.should == 7 }
    it { AutomobileSizeClass.where("conventional_fuel_efficiency_city_multiplier < 1.0").count.should == 7 }
    it { AutomobileSizeClass.where("conventional_fuel_efficiency_highway_multiplier < 1.0").count.should == 7 }
    
    describe '.fallback' do
      it { AutomobileSizeClass.fallback.hybrid_fuel_efficiency_city_multiplier.should == 1.651 }
      it { AutomobileSizeClass.fallback.hybrid_fuel_efficiency_highway_multiplier.should == 1.213 }
      it { AutomobileSizeClass.fallback.conventional_fuel_efficiency_city_multiplier.should == 0.987 }
      it { AutomobileSizeClass.fallback.conventional_fuel_efficiency_highway_multiplier.should == 0.996 }
    end
  end
end
