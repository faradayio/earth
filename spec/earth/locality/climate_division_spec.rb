require 'spec_helper'
require 'earth/locality/climate_division'

describe ClimateDivision do
  describe 'Sanity check', :sanity => true do
    let(:total) { ClimateDivision.count }
    
    it { total.should == 359 }
    it { ClimateDivision.where('heating_degree_days > 0').count.should == total }
    it { ClimateDivision.where('cooling_degree_days >= 0 ').count.should == total }
    it { ClimateDivision.where(:state_postal_abbreviation => nil).count.should == 0 }
  end
end
