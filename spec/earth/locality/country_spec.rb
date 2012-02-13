require 'spec_helper'
require 'earth/locality'
require 'earth/locality/data_miner'

describe Country do
  describe 'import', :slow => true do
    it 'should import data' do
      Earth.init 'locality', :load_data_miner => true, :apply_schemas => true
      Country.run_data_miner!
      Country.all.count.should == 249
    end
  end
end
