require 'spec_helper'
require 'earth/automobile'
require 'earth/automobile/data_miner'

describe AutomobileTypeFuelYearAge do
  describe 'import' do
    it 'imports and processes data successfully' do
      expect do
        AutomobileTypeFuelYearAge.run_data_miner!
      end.should_not raise_error
    end
  end
end

