require 'earth/locality'
class ComputationCarrier < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "computation_carriers"
  (
     "name"                      CHARACTER VARYING(255) NOT NULL,
     "power_usage_effectiveness" FLOAT
  );
ALTER TABLE "computation_carriers" ADD PRIMARY KEY ("name")
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
