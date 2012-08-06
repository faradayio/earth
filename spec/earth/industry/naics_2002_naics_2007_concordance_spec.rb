require 'spec_helper'
require 'earth/industry/naics_2002_naics_2007_concordance'

describe Naics2002Naics2007Concordance do
  let(:n2n) { Naics2002Naics2007Concordance }
  
  describe '.extract_note(description)' do
    it "extracts a paranthetical note from a description" do
      n2n.extract_note("Internet Service Providers - Internet services providers providing services via client-supplied telecommunications connection").
        should == "Internet services providers providing services via client-supplied telecommunications connection"
    end
  end
  
  describe 'Sanity check', :sanity => true do
    it 'should have all the data' do
      n2n.count.should == 1200
    end
    
    # spot check
    it { n2n.where(:naics_2002_code => '111219').map(&:naics_2007_code).should == ['111219', '111211'] }
  end
end
