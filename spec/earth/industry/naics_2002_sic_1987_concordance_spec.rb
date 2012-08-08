require 'spec_helper'
require 'earth/industry/naics_2002_sic_1987_concordance'

describe Naics2002Sic1987Concordance do
  let(:n2s) { Naics2002Sic1987Concordance }
  
  describe '.extract_note(description)' do
    it "extracts a paranthetical note from a description" do
      n2s.extract_note("Wood Household Furniture, Except Upholstered (wood box spring frames(parts))").
        should == "wood box spring frames(parts)"
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it 'should have all the data' do
      n2s.count.should == 2164
    end
    
    # spot check
    it { n2s.where(:naics_2002_code => '111150').map(&:sic_1987_code).should == ['0119', '0115'] }
  end
end
