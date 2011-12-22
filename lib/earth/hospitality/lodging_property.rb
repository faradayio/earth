# Copyright 2011 Brighter Planet, Inc.
class LodgingProperty < ActiveRecord::Base
  set_primary_key :northstar_id
  
  col :northstar_id
  col :name
  col :city
  col :locality # state / province / etc.
  col :postcode # zip code / postal code / etc.
  col :country_iso_3166_alpha_3_code
  col :chain_name
  col :lodging_rooms,     :type => :integer
  col :floors,            :type => :integer
  col :construction_year, :type => :integer
  col :renovation_year,   :type => :integer
  col :lodging_class_name
  col :restaurant
  col :air_conditioning
  col :mini_bar
  col :refrigerator
  col :hot_tub
  col :pools_indoor,  :type => :integer
  col :pools_outdoor, :type => :integer
  col :update_date
end
