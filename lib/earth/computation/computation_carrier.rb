require 'falls_back_on'

require 'earth/model'

class ComputationCarrier < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "computation_carriers"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "power_usage_effectiveness" FLOAT
  );
EOS

  self.primary_key = "name"
  
  falls_back_on :name => 'fallback',
                :power_usage_effectiveness => lambda { ComputationCarrier.maximum('power_usage_effectiveness') }
  
  
  # verify "Power usage effectiveness should be one or more" do
  #   ComputationCarrier.all.each do |carrier|
  #     unless carrier.power_usage_effectiveness >= 1.0
  #       raise "Invalid power usage effectiveness for ComputationCarrier #{carrier.name}: #{carrier.power_usage_effectiveness} (should be >= 1.0)"
  #     end
  #   end
  # end

  warn_unless_size 1
end
