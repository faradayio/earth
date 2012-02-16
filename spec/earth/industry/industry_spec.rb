require 'spec_helper'
require 'earth/industry/industry'
require 'earth/industry/industry/data_miner'

describe Industry do
  it 'translates NAICS codes to SICs', :slow => true do 
    Industry.auto_upgrade!
    Industry.run_data_miner!

    {
      '111140' => '111',
      '111920' => '131',
      '238910' => '1081',
      '488119' => '4581'
    }.each do |naics, sic|
      Industry.find_by_naics_code(naics).sic.should == sic
    end
  end
end

