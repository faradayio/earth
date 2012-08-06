require 'earth/model'
require 'falls_back_on'

class ComputationCarrier < ActiveRecord::Base
  extend Earth::Model

  TABLE_STRUCTURE = <<-EOS

CREATE TABLE computation_carriers
  (
     name                      CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     power_usage_effectiveness FLOAT
  );

EOS

  self.primary_key = "name"
  
  falls_back_on :name => 'fallback',
                :power_usage_effectiveness => lambda { ComputationCarrier.maximum('power_usage_effectiveness') }
  
  warn_unless_size 1
end
