require 'spec_helper'
require 'earth/locality/egrid_country'

describe EgridCountry do
  describe 'verify imported data', :sanity => true do
    it { EgridCountry.count.should == 1 }
    it { EgridCountry.us.loss_factor.should be_within(5e-6).of(0.06503) }
  end
  
  describe '.us' do
    it 'should return the US' do
      EgridCountry.us.should == EgridCountry.find('U.S.')
    end
  end
end
