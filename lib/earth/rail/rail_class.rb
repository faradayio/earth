class RailClass < ActiveRecord::Base
  set_primary_key :name
  
  has_many :rail_trips

  data_miner do
    tap "Brighter Planet's rail class data", Earth.taps_server
  end
  
  # speed is missing
  # https://brighterplanet.sifterapp.com/projects/30/issues/455
  falls_back_on :passengers => 25.06,
                :distance => 8.57.miles.to(:kilometres),
                :diesel_intensity => 0.05.gallons_per_mile.to(:litres_per_kilometre),
                :electricity_intensity => 8.89.miles.to(:kilometres)
end
