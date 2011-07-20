require 'spec_helper'
require 'earth/air/aircraft'
require 'earth/air/aircraft/data_miner'

describe Aircraft do
  describe 'import', :slow => true do
    it 'should treat empty cells as null' do
      Aircraft.force_schema!
      Aircraft.run_data_miner!
      Aircraft.count.should > 1
      Aircraft.where(:brighter_planet_aircraft_class_code => nil).should_not be_empty
    end
  end
end
