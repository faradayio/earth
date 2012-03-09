require 'spec_helper'
require 'earth/industry/naics_2007'

describe Naics2007 do
  before :all do
    Naics2007.auto_upgrade!
  end
  
  describe "when importing data", :data_miner => true do
    before do
      require 'earth/industry/naics_2007/data_miner'
    end
    
    it "imports all naics codes" do
      Naics2007.run_data_miner!
      Naics2007.count.should == 2328
    end
  end
  
  describe "code translations" do
    before do
      require 'earth/industry/naics_2002'
      require 'earth/industry/naics_2002_naics_2007_concordance'
    end
    
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
