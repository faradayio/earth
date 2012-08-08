require 'spec_helper'
require 'earth/rail/rail_company'

describe RailCompany do
  describe 'Sanity check', :sanity => true do
    it { RailCompany.count.should == 97 }
    
    # sanity check
    let(:amtrak) { RailCompany.find 'AMTRAK' }
    it { amtrak.passengers.should == 27279200 }
    it { amtrak.passenger_distance.should == 9517810000 }
    it { amtrak.trip_distance.should be_within(5e-4).of(348.904) }
    it { amtrak.train_distance.should == 61637900 }
    it { amtrak.train_time.should == 1162250 }
    it { amtrak.speed.should be_within(5e-5).of(53.0333) }
    it { amtrak.electricity_intensity.should be_within(5e-5).of(0.0655) }
    it { amtrak.diesel_intensity.should be_within(5e-5).of(0.0256) }
    it { amtrak.co2_emission_factor.should be_within(5e-6).of(0.10782) }
  end
end
