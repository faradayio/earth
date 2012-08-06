require 'spec_helper'
require 'earth/locality/egrid_country'

describe EgridCountry do
  describe '.us' do
    it 'should return the US' do
      us = EgridCountry.find_or_create_by_name 'U.S.'
      EgridCountry.us.should == us
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it { EgridCountry.count.should == 1 }
    it { EgridCountry.us.loss_factor.should be_within(5e-6).of(0.06503) }
  end
end
