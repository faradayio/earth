require 'spec_helper'
require 'earth/locality/egrid_region'

describe EgridRegion do
  describe 'verify imported data', :sanity => true do
    it { EgridRegion.count.should == 5 }
    it { EgridRegion.where("loss_factor > 0").count.should == EgridRegion.count }
    
    # spot check
    it { EgridRegion.first.loss_factor.should be_within(5e-6).of(0.05840) }
  end
  
  describe '.fallback' do
    it { EgridRegion.fallback.name.should == 'fallback' }
    it { EgridRegion.fallback.loss_factor.should be_within(5e-6).of(0.06503) }
  end
end
