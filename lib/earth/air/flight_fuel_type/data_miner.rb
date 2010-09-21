FlightFuelType.class_eval do
  data_miner do
    schema do
      string 'name'
      float  'emission_factor'
      float  'radiative_forcing_index'
      float  'density'
    end
    
    # we just always use the fallback
  end
end
