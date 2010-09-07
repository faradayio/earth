module Earth
  module Base
    def define_schema(data_miner)
      data_miner.schema Earth.database_options, &self.schema_definition
    end
  end
end
