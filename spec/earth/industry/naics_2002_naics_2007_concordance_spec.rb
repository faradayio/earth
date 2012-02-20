require 'spec_helper'
require 'earth/industry/naics_2002_naics_2007_concordance'

describe Naics2002Naics2007Concordance do
  before :all do
    Naics2002Naics2007Concordance.auto_upgrade!
  end
  
  describe "when importing data", :slow => true do
    before do
      require 'earth/industry/naics_2002_naics_2007_concordance/data_miner'
    end
    
    it "extracts a note from a description" do
      Naics2002Naics2007Concordance.extract_note("Internet Service Providers - Internet services providers providing services via client-supplied telecommunications connection").
        should == "Internet services providers providing services via client-supplied telecommunications connection"
    end
    
    it "imports all naics codes" do
      Naics2002Naics2007Concordance.run_data_miner!
      Naics2002Naics2007Concordance.count.should == 1200
    end
  end
  
  describe "relationships" do
    before do
      require 'earth/industry/naics_2002'
      require 'earth/industry/naics_2007'
    end
    
    it "belongs to :naics_2002" do
      Naics2002Naics2007Concordance.find_by_naics_2002_code("111219").
        naics_2002.should == Naics2002.find("111219")
    end
    
    it "belongs to :naics_2007" do
      Naics2002Naics2007Concordance.find_by_naics_2007_code("111211").
        naics_2007.should == Naics2007.find("111211")
    end
  end
end
