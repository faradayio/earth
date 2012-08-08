require 'spec_helper'
require 'earth/industry/sic_1987'

describe Sic1987 do
  describe "Sanity check", :sanity => true do
    it { Sic1987.count.should == 1004 }
    it { Sic1987.where(:description => nil).count.should == 0 }
    
    it "can be translated to a NAICS 2002 code" do
      {
        '0119' => %w{ 111120 111130 111150 111191 111199 },
        '0131' => %w{ 111920 },
      }.each do |sic, naics|
        Sic1987.find(sic).naics_2002.map(&:code).sort.should == naics
      end
    end
  end
end
