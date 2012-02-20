require 'spec_helper'
require 'earth/industry/sic_1987'

describe Sic1987 do
  before :all do
    Sic1987.auto_upgrade!
  end
  
  describe "when importing data", :slow => true do
    before do
      require 'earth/industry/sic_1987/data_miner'
    end
    
    it "imports all naics codes" do
      Sic1987.run_data_miner!
      Sic1987.count.should == 1004
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "has a description for every code" do
      Sic1987.find_by_description(nil).should be_nil
    end
  end
  
  describe "code translations" do
    before do
      require 'earth/industry/naics_2002'
      require 'earth/industry/naics_2002_sic_1987_concordance'
      
      require 'earth/industry/naics_2007'
      require 'earth/industry/naics_2002_naics_2007_concordance'
      
      require 'earth/industry/industry'
    end
    
    it "can be translated to a NAICS 2002 code" do
      {
        '0119' => %w{ 111120 111130 111150 111191 111199 },
        '0131' => %w{ 111920 },
      }.each do |sic, naics|
        Sic1987.find(sic).naics_2002.map(&:code).sort.should == naics
      end
    end
    
    it "can be translated to an industry code" do
      {
        '0119' => %w{ 111120 111130 111150 111191 111199 },
        '0131' => %w{ 111920 },
      }.each do |sic, industries|
        Sic1987.find(sic).industries.map(&:naics_code).sort.should == industries
      end
    end
  end
end
