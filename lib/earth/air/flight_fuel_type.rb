class FlightFuelType < ActiveRecord::Base
  # this fallback is jet fuel
  falls_back_on :emission_factor =>           (21.09.pounds.to(:kilograms) / 1.gallons.to(:litres)),  # in pounds CO2/gallon fuel: http://www.eia.doe.gov/oiaf/1605/excel/Fuel%20Emission%20Factors.xls
                :radiative_forcing_index =>   2,                                                      # from Matt
                :density =>                   3.057                                                   # kg / gal
  
  data_miner do
    tap "Brighter Planet's sanitized flight fuel type data", Earth.taps_server
    
    # we just always use the fallback
  end
end
