class BusClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :bus_trips
  
  # https://brighterplanet.sifterapp.com/projects/30/issues/454
  falls_back_on :distance => 5.45.miles.to(:kilometres),
                :passengers => 8.25,
                :speed => 19.67.miles.to(:kilometres),
                :duration => 0.277,
                :diesel_intensity => 0.143.gallons_per_mile.to(:litres_per_kilometre),
                :gasoline_intensity => 0.000123.gallons_per_mile.to(:litres_per_kilometre),
                :alternative_fuels_intensity => 0.0517.gallons_per_mile.to(:litres_per_kilometre),
                :fugitive_air_conditioning_emission => 0.0203.pounds_per_mile.to(:kilograms_per_kilometre)

  data_miner do
    tap "Brighter Planet's sanitized bus class data", TAPS_SERVER
  end
end
