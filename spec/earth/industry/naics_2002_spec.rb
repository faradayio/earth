require 'spec_helper'
require 'earth/industry/naics_2002'

describe Naics2002 do
  describe "verify imported data", :sanity => true do
    it "should have all the data" do
      Naics2002.count.should == 2341
    end
  end
  
  describe "code translations" do
    before do
      require 'earth/industry/sic_1987'
      require 'earth/industry/naics_2002_sic_1987_concordance'
      require 'earth/industry/naics_2007'
      require 'earth/industry/naics_2002_naics_2007_concordance'
      require 'earth/industry/industry'
    end
    
    it "can be translated to a SIC 1987 code" do
      {
        '111140' => %w{ 0111 },
        '111150' => %w{ 0115 0119 },
        '111920' => %w{ 0131 },
        '238910' => %w{ 1081 1241 1389 1481 1629 1711 1794 1795 1799 7353 },
        '488119' => %w{ 4581 4959 7997 }
      }.each do |naics, sics|
        Naics2002.find(naics).sic_1987.map(&:code).sort.should == sics
      end
    end
    
    it "can be translated to a NAICS 2007 code" do
      {
        '111150' => %w{ 111150 },
        '111219' => %w{ 111211 111219 }
      }.each do |naics_2002, naics_2007|
        Naics2002.find(naics_2002).naics_2007.map(&:code).sort.should == naics_2007
      end
    end
    
    it "can be translated to an industry" do
      {
        '111150' => '111150',
        '111219' => '111219'
      }.each do |naics, industry|
        Naics2002.find(naics).industry.naics_code.should == industry
      end
    end
  end
end
