require 'spec_helper'
require 'earth/industry/industry'

describe Industry do
  describe "verify imported data", :sanity => true do
    it { Industry.count.should == 2341 }
  end
  
  describe "methods" do
    it "knows whether it's a trade industry (wholesale or retail trade)" do
      Industry.find('42331').trade_industry?.should == true
      Industry.find('445110').trade_industry?.should == true
      Industry.find('4539').trade_industry?.should == true
      Industry.find('33291').trade_industry?.should == false
    end
  end
end
