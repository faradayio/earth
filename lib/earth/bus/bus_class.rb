class BusClass < ActiveRecord::Base
  set_primary_key :name
  
  # https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHY0R0hjZnhRaTIxTnpvRk1HNThwUmc&hl=en&output=html
  falls_back_on :passengers => 7.485,
                :distance => 4.9726.miles.to(:kilometres),
                :speed => 19.849.miles.to(:kilometres),
                :diesel_intensity => 0.13836.gallons_per_mile.to(:litres_per_kilometre),
                :alternative_fuels_intensity => 0.04632038.gallons_per_mile.to(:litres_per_kilometre),
                :air_conditioning_emission_factor => 0.04779 / 1.miles.to(:kilometres)
  
  data_miner do
    tap "Brighter Planet's sanitized bus class data", Earth.taps_server
  end
end
