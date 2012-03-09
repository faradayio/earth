require 'spec_helper'
require 'earth/industry/industry'

describe Industry do
  before :all do
    Industry.auto_upgrade!
  end
  
  describe "when importing data", :data_miner => true do
    before do
      require 'earth/industry/industry/data_miner'
    end
    
    it "imports all naics codes" do
      Industry.run_data_miner!
      Industry.count.should == 2341
    end
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
