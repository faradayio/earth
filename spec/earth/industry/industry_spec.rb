require 'spec_helper'
require "#{Earth::FACTORY_DIR}/industry"

describe Industry do
  describe '.format_naics_code(input)' do
    it 'converts input to an integer and then a string' do
      Industry.format_naics_code(42110).should == '42110'
      Industry.format_naics_code('42110a').should == '42110'
    end
  end
  
  describe '#trade_industry?' do
    it "returns true if the industry is wholesale or retail trade" do
      Industry.delete_all
      FactoryGirl.create(:industry, :corn_farming).trade_industry?.should == false
      FactoryGirl.create(:industry, :retail_trade).trade_industry?.should == true
      FactoryGirl.create(:industry, :wholesale_trade).trade_industry?.should == true
    end
  end
  
  describe "Sanity check", :sanity => true do
    it { Industry.count.should == 2341 }
  end
end
