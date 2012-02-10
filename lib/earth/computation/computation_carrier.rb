require 'earth/locality'
class ComputationCarrier < ActiveRecord::Base
  self.primary_key = "name"
  
  falls_back_on :name => 'fallback',
                :power_usage_effectiveness => lambda { ComputationCarrier.maximum('power_usage_effectiveness') }
  
  col :name
  col :power_usage_effectiveness, :type => :float
  
  # verify "Power usage effectiveness should be one or more" do
  #   ComputationCarrier.all.each do |carrier|
  #     unless carrier.power_usage_effectiveness >= 1.0
  #       raise "Invalid power usage effectiveness for ComputationCarrier #{carrier.name}: #{carrier.power_usage_effectiveness} (should be >= 1.0)"
  #     end
  #   end
  # end
end
