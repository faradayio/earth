require 'spec_helper'
require 'earth/industry/naics_2007'

describe Naics2007 do
  describe 'Sanity check', :sanity => true do
    it { Naics2007.count.should == 2328 }
    
    it "can be translated to a NAICS 2002 code" do
      {
        '111211' => %w{ 111211 111219 },
        '111310' => %w{ 111310 },
      }.each do |naics_2007, naics_2002|
        Naics2007.find(naics_2007).naics_2002.map(&:code).sort.should == naics_2002
      end
    end
  end
end
