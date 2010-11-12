class BusClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :bus_trips
  
  # https://brighterplanet.sifterapp.com/projects/30/issues/454
  falls_back_on :distance => 5.45.miles.to(:kilometres),
                :passengers => 8.25,
                :speed => 19.67.miles.to(:kilometres),
                :diesel_intensity => 0.143.gallons_per_mile.to(:litres_per_kilometre),
                :alternative_fuels_intensity => 0.0517.gallons_per_mile.to(:litres_per_kilometre),
                :air_conditioning_emission_factor => 0.0203.pounds_per_mile.to(:kilograms_per_kilometre)

  data_miner do
    tap "Brighter Planet's sanitized bus class data", Earth.taps_server
  end
end
