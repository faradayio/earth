require 'spec_helper'
require 'earth/automobile/automobile_model'

describe AutomobileModel do
  before :all do
    Earth.init :automobile, :load_data_miner => true
  end
  
  describe 'import', :data_miner => true do
    it 'should import data' do
      AutomobileModel.run_data_miner!
      AutomobileModel.count.should == AutomobileModel.connection.select_value("SELECT COUNT(DISTINCT model_name) FROM #{AutomobileMakeModelYearVariant.quoted_table_name}")
    end
  end
end
