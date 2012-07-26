require 'earth/fuel'
class BusClass < ActiveRecord::Base
  TABLE_STRUCTURE = <<-EOS
CREATE TABLE "bus_classes"
  (
     "name"                                   CHARACTER VARYING(255) NOT NULL PRIMARY KEY,
     "distance"                               FLOAT,
     "distance_units"                         CHARACTER VARYING(255),
     "passengers"                             FLOAT,
     "speed"                                  FLOAT,
     "speed_units"                            CHARACTER VARYING(255),
     "gasoline_intensity"                     FLOAT,
     "gasoline_intensity_units"               CHARACTER VARYING(255),
     "diesel_intensity"                       FLOAT,
     "diesel_intensity_units"                 CHARACTER VARYING(255),
     "cng_intensity"                          FLOAT,
     "cng_intensity_units"                    CHARACTER VARYING(255),
     "lng_intensity"                          FLOAT,
     "lng_intensity_units"                    CHARACTER VARYING(255),
     "lpg_intensity"                          FLOAT,
     "lpg_intensity_units"                    CHARACTER VARYING(255),
     "methanol_intensity"                     FLOAT,
     "methanol_intensity_units"               CHARACTER VARYING(255),
     "biodiesel_intensity"                    FLOAT,
     "biodiesel_intensity_units"              CHARACTER VARYING(255),
     "electricity_intensity"                  FLOAT,
     "electricity_intensity_units"            CHARACTER VARYING(255),
     "air_conditioning_emission_factor"       FLOAT,
     "air_conditioning_emission_factor_units" CHARACTER VARYING(255)
  );
EOS

  self.primary_key = "name"
  
  # https://spreadsheets.google.com/pub?key=0AoQJbWqPrREqdHY0R0hjZnhRaTIxTnpvRk1HNThwUmc&hl=en&output=html
  falls_back_on :passengers => 7.485,
                :distance => 4.9726.miles.to(:kilometres),
                :distance_units => 'kilometres',
                :speed => 19.849.miles.to(:kilometres),
                :speed_units => 'kilometres_per_hour',
                :gasoline_intensity => 0.00064134.gallons_per_mile.to(:litres_per_kilometre),
                :gasoline_intensity_units => 'litres_per_kilometre',
                :diesel_intensity => 0.13836.gallons_per_mile.to(:litres_per_kilometre),
                :diesel_intensity_units => 'litres_per_kilometre',
                :cng_intensity => 0.03175.gallons_per_mile.to(:litres_per_kilometre),
                :cng_intensity_units => 'litres_per_kilometre',
                :lng_intensity => 0.00419.gallons_per_mile.to(:litres_per_kilometre),
                :lng_intensity_units => 'litres_per_kilometre',
                :lpg_intensity => 0.00037.gallons_per_mile.to(:litres_per_kilometre),
                :lpg_intensity_units => 'litres_per_kilometre',
                :methanol_intensity => 0.00021.gallons_per_mile.to(:litres_per_kilometre),
                :methanol_intensity_units => 'litres_per_kilometre',
                :biodiesel_intensity => 0.00979.gallons_per_mile.to(:litres_per_kilometre),
                :biodiesel_intensity_units => 'litres_per_kilometre',
                :electricity_intensity => 0.00001804 / 1.miles.to(:kilometres),
                :electricity_intensity_units => 'kilowatt_hours_per_kilometre',
                :air_conditioning_emission_factor => 0.04779 / 1.miles.to(:kilometres),
                :air_conditioning_emission_factor_units => 'kilograms_co2e_per_kilometre'
  

  warn_unless_size 2
end
