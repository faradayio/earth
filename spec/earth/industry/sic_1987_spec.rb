require 'spec_helper'
require 'earth/industry/sic_1987'

describe Sic1987 do
  describe "when importing data", :data_miner => true do
    before do
      Earth.init :industry, :load_data_miner => true, :skip_parent_associations => :true
    end
    
    it "imports all naics codes" do
      Sic1987.run_data_miner!
    end
  end
  
  describe "verify imported data", :sanity => true do
    it "should have all the data" do
      Sic1987.count.should == 1004
    end
    it "has a description for every code" do
      Sic1987.find_by_description(nil).should be_nil
    end
  end
  
  describe "code translations" do
    before do
      require 'earth/industry/naics_2002'
      require 'earth/industry/naics_2002_sic_1987_concordance'
    end
    
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
