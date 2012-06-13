require 'spec_helper'
require 'earth/industry/industry'

describe Industry do
  describe "when importing data", :data_miner => true do
    before do
      Earth.init :industry, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it "imports all naics codes" do
      Industry.run_data_miner!
    end
  end
  
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
