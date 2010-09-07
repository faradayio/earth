module Earth
  class Base < ActiveRecord::Base
    def self.define_schema(data_miner)
      data_miner.schema Earth.database_options, &self.schema_definition
    end
  end
end
